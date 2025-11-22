MAKEFLAGS += -rR

CC := clang

BUILD := build
OBJ := $(BUILD)/obj

include scripts/defs.mk

cflags-y += -MMD -MP

ldflags-y += -fuse-ld=lld

PHONY += all
all:

quiet_cmd_clean = CLEAN   $(BUILD)
      cmd_clean = rm -rf $(BUILD)

PHONY += clean
clean:
	$(call cmd,clean)

include src/Makefile

include scripts/build.mk
