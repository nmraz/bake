quiet_cmd_cc = CC      $@
      cmd_cc = $(CC) -MMD -MP $(cflags-y) $(cflags-$(bin-name)-y) $(cflags-$<-y) -c $< -o $@

$(OBJ)/%.o: %.c FORCE
	$(call cmd,cc)

quiet_cmd_ld = LD      $@
      cmd_ld = $(CC) $(ldflags-y) $(ldflags-$(bin-name)-y) $(filter %.o,$^) -o $@

$(BUILD)/%.elf: FORCE
	$(call cmd,ld)

quiet_cmd_objcopy = OBJCOPY $@
      cmd_objcopy = objcopy $(objcopyflags-$@-y) $< $@

bin-outputs = $(bins-y:%=$(BUILD)/%.elf)
targets += $(bin-outputs)

define each-bin
objs-$(bin-name) := $$($(bin-name)-y:%.c=$(OBJ)/%.o)

targets += $$(objs-$(bin-name))

$(BUILD)/$(bin-name).elf: $$(objs-$(bin-name))
$(BUILD)/$(bin-name).elf: bin-name := $(bin-name)

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
.SECONDARY:

-include $(depfiles)
