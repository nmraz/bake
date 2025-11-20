quiet_cmd_cc = CC      $@
      cmd_cc = $(CC) $(cflags-y) $(cflags-$(bin-name)-y) $(cflags-$<-y) -c $< -o $@

quiet_cmd_ld = LD      $@
      cmd_ld = $(CC) $(ldflags-y) $(ldflags-$(bin-name)-y) $(filter %.o,$^) -o $@

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(@D)
	$(call cmd,cc)

$(BIN_DIR)/%.elf:
	@mkdir -p $(@D)
	$(call cmd,ld)

deps :=

define each-bin
objs-$(bin-name) := $$($(bin-name)-y:%.c=$(OBJ_DIR)/%.o)

$(BIN_DIR)/$(bin-name).elf: $$(objs-$(bin-name))
$(BIN_DIR)/$(bin-name).elf: bin-name := $(bin-name)

deps += $$(objs-$(bin-name):%.o=%.d)
endef

_ := $(foreach bin-name,$(bins-y),$(eval $(each-bin)))

all: $(bins-y:%=$(BIN_DIR)/%.elf)

-include $(deps)

.DELETE_ON_ERROR:
