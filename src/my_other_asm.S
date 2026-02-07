.text

.global asm_func
.type asm_func, @function
asm_func:
    xorl %eax, %eax
    ret
.size asm_func, . - asm_func
