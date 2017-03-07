/******************************************************************************
* @FILE calculator.s
*
* Simple calculator program, capable of adding, subtracting, multiplying
* and finding the max value
*
* @AUTHOR Shervin Oloumi
******************************************************************************/

    .global main
    .func main

main:
    BL  _scanf              @ branch to scanf procedure with return
    MOV R11, R0             @ move return value R0 to register R11
    BL  _getchar            @ branch to getchar procedure with return
    MOV R12, R0             @ move return value R0 to register R12
    BL  _scanf              @ branch to scanf procedure with return
    MOV R10, R0             @ move return value R0 to register R10
    BL  _compare            @ determine the requested operation
    B   main                @ branch to main again for a continueous loop

_scanf:
    PUSH {LR}               @ push LR on stack to save it
    PUSH {R12}              @ push R12 on stack because it contans the operand
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointe
    POP {R12}               @ restore R12
    POP {PC}                @ return

_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    CMP R12, #'+'           @ compare against the constant char '+'
    BEQ _add                @ branch to addition handler
    CMP R12, #'-'           @ compare against the constant char '-'
    BEQ _sub                @ branch to subtraction handler
    CMP R12, #'*'           @ compare against the constant char '*'
    BEQ _mult               @ branch to multiplication handler
    CMP R12, #'M'           @ compare against the constant char 'M'
    BEQ _max                @ branch to maximum finder
    BNE main                @ branch to main if none satisfied

_add:
    PUSH {LR}
    ADD R1, R10, R11
    LDR R0, =result_str
    BL printf
    POP {PC}

_sub:
    PUSH {LR}
    SUB R1, R11, R10
    LDR R0, =result_str
    BL printf
    POP {PC}

_mult:
    PUSH {LR}
    MUL R1, R10, R11
    LDR R0, =result_str
    BL printf
    POP {PC}

_max:
    PUSH {LR}
    CMP R10, R11            @ comparing the two ints
    MOVGT R1, R10           @ move R10 to R1 if greater than flag was set
    CMP R10, R11
    MOVLE R1, R11           @ move R11 to R1 if Lower than or equal flag was set
    LDR R0, =result_str
    BL printf
    POP {PC}

.data
result_str:     .asciz      "%d\n"
read_char:      .ascii      " "
format_str:     .ascii      "%d"
