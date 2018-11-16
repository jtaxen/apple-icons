#!/bin/sh

input=$1

height=$(sips -g pixelHeight $input | grep -oE '[0-9]*$')
width=$(sips -g pixelWidth $input | grep -oE '[0-9]*$')

if [ $width -ne 1024 ] && [ $height -ne 1024 ]; then
	echo "Image dimensions must be 1024x1024 square pixels"
	exit 1
fi

prefix="Icon"

sizes=(20 29 40 60 76 83.5 1024)
multipliers=(1 2 3)

for s in ${sizes[@]}; do
	for m in ${multipliers[@]}; do
		dim=$(echo "$s * $m" | bc)
		postfix=
		case $m in
			1)
				postfix=""
				;;
			2)
				postfix="@2x"
				;;
			3)
				postfix="@3x"
				;;
			*)
				echo "Multiplier error"
				exit 1
				;;
		esac

		sips $input -z $dim $dim --out "$prefix-$s$postfix.png"
	done
done

