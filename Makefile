
BUILD_DIR = ./build
BIN_DIR   = ./bin
SYS_DIR   = ./sys



# Toolchain
CC = i686-elf-gcc
AS = nasm
LD = i686-elf-ld
OBJCOPY = i686-elf-objcopy


FLAGS = -g -ffreestanding -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc -Ilibary/include


OBJS = $(BUILD_DIR)/kernel.asm.o \
       $(BUILD_DIR)/port.o \
       $(BUILD_DIR)/vga.o \
       $(BUILD_DIR)/memory.o

	

.PHONY: all clean run gdb-instructions

all: $(BIN_DIR)/davidos.iso $(BUILD_DIR)/completeKernel.o




# ensure directories exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

#bootloader (raw binary)
$(BIN_DIR)/boot.bin: $(SYS_DIR)/boot.asm | $(BIN_DIR)
	$(AS) -f bin $< -o $@

# Assemble kernel as elf32 object
$(BUILD_DIR)/kernel.asm.o: $(SYS_DIR)/kernel.asm | $(BUILD_DIR)
	$(AS) -f elf32 -g $< -o $@

#asm port
$(BUILD_DIR)/port.o: $(SYS_DIR)/port.asm | $(BUILD_DIR)
	$(AS) -f elf32 -g $< -o $@

#asm vga
$(BUILD_DIR)/vga.o: $(SYS_DIR)/vga.asm | $(BUILD_DIR)
	$(AS) -f elf32 -g $< -o $@
#asm memory
$(BUILD_DIR)/memory.o: $(SYS_DIR)/memory.asm | $(BUILD_DIR)
	$(AS) -f elf32 -g $< -o $@

	
# Link flat binary kernel using your linker.ld (script expects to produce binary)
# Output: bin/kernel.bin (flat binary)
$(BIN_DIR)/kernel.bin: $(OBJS) $(SYS_DIR)/linker.ld | $(BIN_DIR)
	$(LD) -T $(SYS_DIR)/linker.ld -o $@ $(OBJS)


$(BUILD_DIR)/completeKernel.o: $(OBJS) | $(BUILD_DIR)
	$(LD) -r -o $@ $(OBJS)








# New: 
$(BIN_DIR)/davidos.iso: $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin 
	dd if=/dev/zero of=$@ bs=512 count=65536
	dd if=$(BIN_DIR)/boot.bin of=$@ bs=512 seek=0 conv=notrunc
	dd if=$(BIN_DIR)/kernel.bin of=$@ bs=512 seek=1 conv=notrunc



clean:
	rm -rf $(BIN_DIR) $(BUILD_DIR)