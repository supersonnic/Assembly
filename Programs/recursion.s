/******************************************************************************
* @FILE recursion.s
*
* Recursive solution for counting the number of partitions of an integer,
* using another maximum integer.
*
* @AUTHOR Shervin Oloumi
******************************************************************************/

    .global main
    .func main

main:

    BL  _scanf      		    @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to register R1 (n)
    BL  _scanf              @ branch to scanf procedure with return
    MOV R2, R0              @ move return value R0 to register R2 (m)
    BL  _count_part         @ call teh recursive function
    MOV R4, R3              @ back-up teh return value to R4
    MOV R3, R2              @ set R2 (m) as the 3rd printf argument
    MOV R2, R1              @ set R1 (n) as the 2nd printf argument
    MOV R1, R4              @ set R4 (result) as the 1s printf argument
    BL  _printf             @ call printf to display the result
    B   main                @ branch to main again for a continueous loop


_count_part:

    PUSH {LR}               @ back-up link register

    CMP R1, #0              @ comparing R1 (n) to 0
    MOVEQ R3, #1            @ if it's zero, set R3 (result) to 1
    MOVLT R3, #0            @ if R1 is less that 0, then set results to 0
    POPLE {PC}              @ if R1 is less than or equal to 0, return
    CMP R2, #0              @ comparing R2 (m) to 0
    MOVEQ R3, #0            @ if it's zero, set result to 0
    POPEQ {PC}              @ return if m is zero

    PUSH {R1}               @ backing-up R1 befor calling recursion

    SUB R1, R1, R2          @ R1 = R1 - R2
    BL _count_part          @ call recursive function

    POP {R1}                @ restore R1
    MOV R4, R3              @ make a copy of result as the second recusion over-rides it

    PUSH {R2}               @ back-up R2 in preparation for recursion
    PUSH {R4}               @ back-up R4

    MOV R7, #1              @ set R7 as 1
    SUB R2, R2, R7          @ deduct one from R2
    BL _count_part          @ call recursive function

    POP {R4}                @ restore R4
    POP {R2}                @ restore R2

    ADD R3, R3, R4          @ R3 = R3 + R4 (adding the two return values)
    POP {PC}                @ return


_scanf:

    PUSH {LR}               @ push LR on stack to save it
    PUSH {R1}               @ back-up R1
    PUSH {R2}               @ back-up R2
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointe
    POP {R2}                @ restore R2
    POP {R1}                @ restore R1
    POP {PC}                @ return


_printf:

    PUSH {LR}               @ back-up LR since printf call overwrites
    LDR R0,=print_str       @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ return


.data
print_str:     .asciz       "There are %d partitions of %d using integers up to %d\n"
format_str:    .asciz       "%d"
