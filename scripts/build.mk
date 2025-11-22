quiet_cmd_cc = CC      $@
      cmd_cc = $(CC) $(cflags-y) $(cflags-$(bin-name)-y) $(cflags-$<-y) -c $< -o $@

$(OBJ_DIR)/%.o: %.c FORCE
	$(call cmd,cc)

quiet_cmd_ld = LD      $@
      cmd_ld = $(CC) $(ldflags-y) $(ldflags-$(bin-name)-y) $(filter %.o,$^) -o $@

$(BUILD_DIR)/%.elf: FORCE
	$(call cmd,ld)

bin-outputs = $(bins-y:%=$(BUILD_DIR)/%.elf)
targets += $(bin-outputs)

define each-bin
objs-$(bin-name) := $$($(bin-name)-y:%.c=$(OBJ_DIR)/%.o)

targets += $$(objs-$(bin-name))

$(BUILD_DIR)/$(bin-name).elf: $$(objs-$(bin-name))
$(BUILD_DIR)/$(bin-name).elf: bin-name := $(bin-name)

depfiles += $$(objs-$(bin-name):%.o=%.d)
endef

$(foreach bin-name,$(bins-y),$(eval $(each-bin)))

all: $(bin-outputs)

PHONY += FORCE
FORCE: ;

existing-targets := $(wildcard $(sort $(targets)))
depfiles += $(existing-targets:%=%.cmd)

.PHONY: $(PHONY)
.DELETE_ON_ERROR:

-include $(depfiles)
