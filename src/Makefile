libs-y += mylib
mylib-y += src/mylib.c

bins-y += mybin

cflags-mybin-y += -flto
mybin-y += src/my_main.c
cflags-src/my_main.c-y += -mno-red-zone
ldflags-mybin-y += -static-pie
ldlibs-mybin-y += m
ldbuiltlibs-mybin-y += mylib

bins-y += otherbin
otherbin-y += src/my_other_main.c
otherbin-y += src/my_other_asm.S
ldbuiltlibs-otherbin-y += mylib

quiet_cmd_mkotherbin = OBJCOPY $@
      cmd_mkotherbin = objcopy -O binary -j .text $< $@

targets += $(BUILD)/otherbin.bin
$(BUILD)/otherbin.bin: $(BUILD)/otherbin FORCE
	$(call cmd,mkotherbin)

all: $(BUILD)/otherbin.bin
