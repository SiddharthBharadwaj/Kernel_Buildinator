#!/bin/bash

# Source vars.conf to get all the stored variables
source $sdir/vars.conf

# Change Current Directory to AnyKernel3
cd "$sdir/AnyKernel3"

# Make Base Clean to ZIP
git reset --hard
git clean -f -d

# Change anykernel script values
sed -i "s|^kernel.string=.*|kernel.string=$kstring|g" "$sdir/AnyKernel3/anykernel.sh"
sed -i "s|^device.name1=.*|device.name1=$dname|g" "$sdir/AnyKernel3/anykernel.sh"
sed -i "s|^block.*|block=$block;|g" "$sdir/AnyKernel3/anykernel.sh"
sed -i "s|^supported.versions=.*|supported.versions=|g" "$sdir/AnyKernel3/anykernel.sh"
sed -i "s|^supported.patchlevels=.*|supported.patchlevels=|g" "$sdir/AnyKernel3/anykernel.sh"
sed -i '/# begin ramdisk changes/,/# end ramdisk changes/d' "$sdir/AnyKernel3/anykernel.sh"
sed -i 's/toro//g' "$sdir/AnyKernel3/anykernel.sh"
sed -i 's/plus//g' "$sdir/AnyKernel3/anykernel.sh"
sed -i 's/tuna//g' "$sdir/AnyKernel3/anykernel.sh"

# Copy zIMAGE/Image.gz-dtb from kernel out
if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]
then
mv $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $sdir/AnyKernel3/Image.gz-dtb
elif [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]
then
mv $KERNEL_DIR/out/arch/arm/boot/zImage $sdir/AnyKernel3/zImage
fi

# Create AnyKernel Zip
zip -r9 $ZIPNAME * -x .git README.md
echo -e "\e[1;32mFlashable ZIP Created Succesfully\e[0m"
