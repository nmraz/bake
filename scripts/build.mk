quiet_cmd_cc = CC      $@
      cmd_cc = $(CC) -MMD -MP $(cflags-y) $(cflags-$(linktarget)-y) $(cflags-$<-y) -c $< -o $@

all-ldlibs = $(addprefix -l,$(ldlibs-$(bin-name)-y))

quiet_cmd_ld = LD      $@
      cmd_ld = $(CC) $(ldflags-y) $(ldflags-$(bin-name)-y) $(objs-$(bin-name)) $(all-ldlibs) -o $@

bin-outputs = $(addprefix $(BUILD)/,$(bins-y))
targets += $(bin-outputs)

define each-bin
objs-$(bin-name) := $$($(bin-name)-y:%.c=$(OBJ)/$(bin-name)/%.o) $$(objs-$(bin-name))

targets += $$(objs-$(bin-name))

$$(objs-$(bin-name)): private linktarget := $(bin-name)
$$(objs-$(bin-name)): $(OBJ)/$(bin-name)/%.o: %.c FORCE
	$$(call cmd,cc)

$(BUILD)/$(bin-name): private bin-name := $(bin-name)
$(BUILD)/$(bin-name): $$(objs-$(bin-name)) FORCE
	$$(call cmd,ld)

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
