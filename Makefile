export srcroot := .
export objroot := build/obj

ifeq ($(V),1)
Q :=
else
Q := @
endif

export Q

export CC := gcc
export AR := ar

include $(srcroot)/makefiles/defs.mk
