# Codetype Formatters (C0, C2, C3, and C4)

.ifndef MACROS_S
.equ MACROS_S, 1

# ex. WRITEADDR 0xDEADCAFE, "nop"
.macro WRITEADDR addr, code
    .short 0xc400
    .short (quickwrite_end_\@-quickwrite_start_\@)/4
    .long \addr
    quickwrite_start_\@:
    \code
    quickwrite_end_\@:
    .align 3
.endm

# must use the following two macros together
# ex. WRITE 0xDEADCAFE
# .long 0x12345678
# .long 0x9ABCDEF0
# ENDWRITE
.macro WRITE addr
    .altmacro
    .short 0xc400
    .short (write_end_\@-write_start_\@)/4
    .long \addr
    .set track_write, \@
    write_start_\@:
    .noaltmacro
.endm

.macro ENDWRITE
    .altmacro
    .irp count,%track_write
    write_end_\count:
    .endr
    .align 3
    .noaltmacro
.endm

# must use the following two macros together
# ex. HOOK 0xDEADCAFE
# .long 0x12345678
# .long 0x9ABCDEF0
# ENDHOOK
.macro HOOK addr
    .altmacro
    .short 0xc200
    .short (hook_end_\@-hook_start_\@)/8
    .long \addr
    .set track_hook,\@
    hook_start_\@:
    .noaltmacro
.endm

.macro HOOK_CTR addr
    .altmacro
    .short 0xc300
    .short (hook_end_\@-hook_start_\@)/8
    .long \addr
    .set track_hook,\@
    hook_start_\@:
    .noaltmacro
.endm

.macro ENDHOOK
    .altmacro
    .align 3
    .irp count,%track_hook
    hook_end_\count:
    .endr
    .noaltmacro
.endm

# must use the following two macros together
# ex. HOOK 0xDEADCAFE
# nop
# blr
# ENDHOOK
.macro EXEC
    .altmacro
    .short 0xc000
    .short (exec_end_\@-exec_start_\@)/8
    .set track_exec,\@
    exec_start_\@:
    .noaltmacro
.endm

.macro ENDEXEC
    .altmacro
    .align 3
    .irp count,%track_exec
    exec_end_\count:
    .endr
    .noaltmacro
.endm

.macro CALL symbol
    lis %r12, \symbol@h
    ori %r12, %r12, \symbol@l
    mtctr %r12
    bctrl
.endm

.endif
