## Kernel Buildinator

Ever wanted to compile/build a kernel ? But don't want to learn all the commands ?
Then here comes a tool for you "Kernel Buildinator". Now, no need to learn any commands.

## Requirements
    Linux

## How to use

### Download tools
```
git clone https://github.com/SiddharthBharadwaj/Kernel_Buildinator.git
cd Kernel_Buildinator
```

### For setting up requirement and starting the build
```
    bash setup.sh
```
```
Notes:
- If you select not to clone kernel source then copy/move your local kernel sources to "Kernel_buildinator/kernel"
- Toolchains & Anykernel will only be cloned if "Kernel_buildinator/kernel" exists
- If your device is having block different then "/dev/block/bootdevice/by-name/boot", then you have to manually 
  change it in vars.conf (Only If You Are Going To Use AnyKernel3)
```

### Things you must know before starting

- ARCH & SUBARCH
- DEFCONFIG Name

check setup.sh for more info

## TO-DO

- Add more options for Anykernel (like devicename etc...)
- Add an option ignore GCC/Clang warnings

## Credits

- @osm0sis for AnyKernel
- @rebenok90x for https://github.com/rebenok90x/kernel-builder

### Help & Pull Requests are always Welcome
