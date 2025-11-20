ifeq ($(V),1)
quiet :=
else
quiet := quiet_
endif

squote  := '

escsq = $(subst $(squote),'\$(squote)',$1)

log-cmd = echo '  $(call escsq,$($(quiet)cmd_$(1)))'
cmd = @set -e; $(log-cmd); $(cmd_$(1))

cflags-y :=
bins-y :=
