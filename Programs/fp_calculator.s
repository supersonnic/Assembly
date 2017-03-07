/******************************************************************************
* @FILE fp_calculator.s

* @BRIEF simple floating point calculator

* @AUTHOR Shervin Oloumi
******************************************************************************/

    .global main
    .func main

main:
    BL  _scanf              @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to argument register R1
    BL  _scanf              @ call scanf again for the second number
    MOV R2, R0              @ move the second number to register R2
    BL  _divide             @ calling divide with return
    BL  _printf             @ branch to print procedure with return
    MOV R1, R3
    MOV R2, R4
    BL  _print_res
    B   main

_divide:
    PUSH {LR}
    VMOV S0, R1             @ load the first value intoto VFP register S0
    VMOV S1, R2             @ load the second value into VFP register S1
    VDIV.F32 S3, S0, S1     @ perform the division of the two 32 bit floats
    VCVT.F64.F32 D4, S3     @ covert result to double precision to print
    VMOV R3, R4, D4         @ break down the result to R1 and R2
    POP {PC}

_printf:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

_print_res:
    PUSH {LR}               @ store LR since printf call overwrites
    LDR R0, =printf_res     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    PUSH {R1}
    PUSH {R2}
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {R2}
    POP {R1}
    POP {PC}                @ return

.data
format_str:     .asciz      "%d"
printf_str:     .asciz      "%d / %d = "
printf_res:     .asciz      "%f\n"
