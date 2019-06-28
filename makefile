PROJNAME = rtos
TARGET   = LM3S811

SHELL    = /bin/bash

SRCDIR   = ./src
BUILDDIR = ./build
INCDIR   = ./inc

CC       = arm-none-eabi-gcc
OBJCOPY  = arm-none-eabi-objcopy
OBJSIZE  = arm-none-eabi-size

CFLAGS   = -std=c99 -Wall -Og -ggdb
CFLAGS  += -mcpu=cortex-m3
CFLAGS  += -mthumb
CFLAGS  += -mfloat-abi=soft
CFLAGS  += $(addprefix -I,$(INCDIR))
CFLAGS  += -ffunction-sections -fdata-sections

LDSCRIPT = mylinker.ld
LDFLAGS  = -T$(LDSCRIPT) -nostartfiles -ggdb
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,-Map=$(BUILDDIR)/$(PROJNAME).map

DEPFLAGS = -MT $@ -MMD -MP -MF $(BUILDDIR)/$*.Td

SRC_C    = $(wildcard $(addsuffix /*.c, $(SRCDIR)))
SRC_S    = $(wildcard $(addsuffix /*.S, $(SRCDIR)))

OBJ      = $(addprefix $(BUILDDIR)/, $(notdir $(SRC_S:.S=.o)))
OBJ     += $(addprefix $(BUILDDIR)/, $(notdir $(SRC_C:.c=.o)))

ELF      = $(addsuffix .elf, $(BUILDDIR)/$(PROJNAME))
BIN      = $(addsuffix .bin, $(BUILDDIR)/$(PROJNAME))

POSTCC   = @mv -f $(BUILDDIR)/$*.Td $(BUILDDIR)/$*.d && touch $@

$(shell mkdir -p $(BUILDDIR))

vpath %.c $(SRCDIR)
vpath %.S $(SRCDIR)

all: $(BIN)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
	$(OBJSIZE) $<

$(ELF): $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $@

$(BUILDDIR)/%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.o : %.c
$(BUILDDIR)/%.o : %.c $(BUILDDIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) -c $< -o $@
	$(POSTCC)

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)

.PHONY: dump
dump:
	arm-none-eabi-objdump -d $(ELF) | less

.PHONY: ddump
ddump:
	arm-none-eabi-objdump -D $(ELF) | less

.PHONY: flash
flash: $(BIN)
	st-flash write $(BIN) 0x08000000

.PHONY: print
print:
	@echo $(SRC_C)
	@echo $(SRC_S)

$(BUILDDIR)/%.d: ;
.PRECIOUS: $(BUILDDIR)/%.d

include $(wildcard $(patsubst %,$(BUILDDIR)/*.d,$(basename $(SRC_C))))
