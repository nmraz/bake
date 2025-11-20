bins-y += mybin

cflags-mybin-y += -flto
mybin-y += src/my_main.c
cflags-src/my_main.c-y += -mno-red-zone
ldflags-mybin-y += -static-pie

bins-y += otherbin
otherbin-y += src/my_other_main.c
