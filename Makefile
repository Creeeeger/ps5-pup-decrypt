CC      := gcc
AS      := gcc
ODIR    := build
SDIR    := source
IDIRS   := -I. -Iinclude
LDIRS   := -L. -Llib
CFLAGS  := $(IDIRS) -fno-builtin -nostdlib -Wall -m64 -fPIC -mcmodel=small -g
SFLAGS  := -fno-builtin -nostartfiles -nostdlib -fPIC -mcmodel=small -g
LFLAGS  := $(LDIRS) -Xlinker -T linker.x -Wl,--build-id=none -Wl,--allow-multiple-definition,-lc,-Lc,-g
CFILES  := $(wildcard $(SDIR)/*.c)
SFILES  := $(wildcard $(SDIR)/*.s)
OBJS    := $(patsubst $(SDIR)/%.c, $(ODIR)/%.o, $(CFILES)) $(patsubst $(SDIR)/%.s, $(ODIR)/%.o, $(SFILES))

TARGET = ps5_pup_decrypt.elf

$(TARGET): $(ODIR) $(OBJS)
	$(CC) crt0.s $(ODIR)/*.o -o $(TARGET) $(CFLAGS) $(LFLAGS)

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: $(SDIR)/%.s
	$(AS) -c -o $@ $< $(SFLAGS)

$(ODIR):
	@mkdir $@

.PHONY: clean debug

debug: $(TARGET)
	gdb ./$(TARGET)

clean:
	rm -f $(shell basename $(CURDIR)).elf $(TARGET) $(ODIR)/*.o
