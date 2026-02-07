quiet_cmd_cc = CC      $@
      cmd_cc = $(CC) -MMD -MP $(cflags-y) $(cflags-$(linktarget)-y) $(cflags-$<-y) -c $< -o $@

ldbuiltlibs = $(ldbuiltlibs-$(bin-name)-y:%=$(BUILD)/%.a)
all-ldlibs = $(addprefix -l,$(ldlibs-$(bin-name)-y)) $(ldbuiltlibs)

quiet_cmd_ld = LD      $@
      cmd_ld = $(CC) $(ldflags-y) $(ldflags-$(bin-name)-y) $(objs-$(bin-name)) $(all-ldlibs) -o $@

quiet_cmd_ar = AR      $@
      cmd_ar = rm -f $@; $(AR) rcs --thin $@ $(objs-$(lib-name))

bin-outputs = $(addprefix $(BUILD)/,$(bins-y))
targets += $(bin-outputs)

define build-objs
objs-$1 := $$($1-y:%.c=$(OBJ)/$1/%.o) $$(objs-$1)

$$(objs-$1): private linktarget := $1
$$(objs-$1): $(OBJ)/$1/%.o: %.c $(ccdeps-y) $(ccdeps-$1-y) FORCE | $(ccodeps-y) $(ccodeps-$1-y)
	$$(call cmd,cc)

targets += $$(objs-$1)
depfiles += $$(objs-$1:%.o=%.d)
endef

define each-bin
$(call build-objs,$(bin-name))

$(BUILD)/$(bin-name): private bin-name := $(bin-name)
$(BUILD)/$(bin-name): $$(objs-$(bin-name)) $$(ldbuiltlibs) $(lddeps-y) $(lddeps-$(bin-name)-y) FORCE
	$$(call cmd,ld)
endef

$(foreach bin-name,$(bins-y),$(eval $(each-bin)))

lib-outputs = $(libs-y:%=$(BUILD)/%.a)
targets += $(lib-outputs)

define each-lib
$(call build-objs,$(lib-name))

$(BUILD)/$(lib-name).a: private lib-name := $(lib-name)
$(BUILD)/$(lib-name).a: $$(objs-$(lib-name)) FORCE
	$$(call cmd,ar)
endef

$(foreach lib-name,$(libs-y),$(eval $(each-lib)))

all: $(bin-outputs)

PHONY += FORCE
FORCE: ;

existing-targets := $(wildcard $(sort $(targets)))
depfiles += $(existing-targets:%=%.cmd)

.PHONY: $(PHONY)
.DELETE_ON_ERROR:
.SECONDARY:

-include $(depfiles)
