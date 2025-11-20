MAKEFLAGS += -rR

CC := gcc

BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin

include makefiles/defs.mk

cflags-y += -MMD -MP

.PHONY: all
all:

quiet_cmd_clean = CLEAN   $(BUILD_DIR)
      cmd_clean = rm -rf $(BUILD_DIR)

.PHONY: clean
clean:
	$(call cmd,clean)

include src/Makefile

include makefiles/build.mk
