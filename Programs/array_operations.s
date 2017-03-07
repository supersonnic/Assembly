/******************************************************************************
* @FILE array_operations.s
* @BRIEF Array Manipulation
*
* This program populates an array of 10 integers using user input and then
* calculates and prints the minimum, the maximum and the sum of all elements.
*
* @AUTHOR Shervin Oloumi
******************************************************************************/


.global main
.func main

main:

    MOV R3, #0              @ initialzing index(i)
    MOV R10, #1024          @ this is where the minimum will be stored
    MOV R11, #0             @ this is where the maximum will be stored
    B _populate             @ function to populate array_a


_populate:

    CMP R3, #10             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =array_a        @ get address of a
    LSL R2, R3, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    BL _scanf               @ getting the user input
    STR R0, [R2]            @ write the user input to a[i]
    ADD R3, R3, #1          @ i = i + 1
    B   _populate           @ branch to next loop iteration


writedone:

    MOV R0, #0              @ initialze index variable
    B _readloop             @ function to iterate array_a and to compute solutions


_readloop:

    CMP R0, #10             @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    ADD R9, R9, R2          @ this calculates the sum of the elements
    CMP R2, R10             @ is the element smaller that the smallest (or 1024)
    MOVLS R10, R2           @ if so, replace the smallest with the current value
    CMP R2, R11             @ is the element larger than the largest (or 0)
    MOVGT R11, R2           @ if so, replace the largest with the current value
    ADD R0, R0, #1          @ increment index
    B   _readloop           @ branch to next loop iteration


_printf:

    PUSH {LR}               @ store the return address
    PUSH {R0}               @ backup register R0 before printf
    PUSH {R1}               @ backup register R1 before printf
    PUSH {R2}               @ backup register R2 before printf
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {R2}                @ restore register R2
    POP {R1}                @ restore register R1
    POP {R0}                @ restore register R0
    POP {PC}                @ restore the stack pointer and return


_print_sol:

    PUSH {LR}               @ store the return address
    LDR R0, =printf_sol     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return


_scanf:

    PUSH {LR}               @ back up LR
    PUSH {R1}               @ back up R1
    PUSH {R2}               @ back up R2
    PUSH {R3}               @ bakc up R3
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R3 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointe
    POP {R3}                @ restore R3
    POP {R2}                @ restore R2
    POP {R1}                @ restore R1
    POP {PC}                @ restore LR


readdone:

    MOV R1, R10             @ move min to R1 as printf first argument
    MOV R2, R11             @ move max to R2 as printf second argument
    MOV R3, R9              @ move sum to R3 as printf third argument
    BL _print_sol           @ call printf for solution
    B _exit                 @ exit


_exit:

    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


.data

.balign 4
array_a:        .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
printf_sol:     .asciz      "minimum = %d\nmaximum = %d\nsum = %d\n"
format_str:     .asciz      "%d"
