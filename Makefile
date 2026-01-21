MAKEFLAGS += -rR

CC := clang

BUILD ?= build

# Force $(BUILD) to be evaluated now
BUILD := $(BUILD)
OBJ := $(BUILD)/obj

include scripts/defs.mk

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
