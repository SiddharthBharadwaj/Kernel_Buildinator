#!/bin/bash

# Source vars.conf to get all the stored variables
source $sdir/vars.conf

# Change Current Directory to AnyKernel3
cd "$KERNEL_DIR/AnyKernel3"

# Make Base Clean to ZIP
git reset --hard

# Change anykernel script values
sed -i "s|^kernel.string=.*|kernel.string=$kstring|g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s|^device.name1=.*|device.name1=$dname|g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s|^block.*|block=$block;|g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s|^supported.versions=.*|supported.versions=|g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i "s|^supported.patchlevels=.*|supported.patchlevels=|g" "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i '/# begin ramdisk changes/,/# end ramdisk changes/d' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/toro//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/plus//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"
sed -i 's/tuna//g' "$KERNEL_DIR/AnyKernel3/anykernel.sh"

# Copy zIMAGE/Image.gz-dtb from kernel out
cp -r $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $KERNEL_DIR/AnyKernel3/Image.gz-dtb

# Create AnyKernel Zip
zip -r9 $ZIPNAME * -x .git README.md
echo -e "\e[1;32mFlashable ZIP Created Succesfully\e[0m"
