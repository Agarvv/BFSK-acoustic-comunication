.section .rodata

msg:
.asciz "xd\n"

.align 2           
TWO_PI:
.float 6.2831853072


.section .text
.global adft
// .global main 
.extern sin
.extern cos


pru:
b pru 

adft:
    ADRP    x10, TWO_PI
    ADD     x10, x10, :lo12:TWO_PI

    
    
    LDR     s2, [x10] // 2pi in s2
    SCVTF   s1, x1 // N

    MOV     x12, xzr 
    MOV     x10, xzr 
    MOV     x20, xzr // x[n] index for imaginary parts
    MOV     x21, xzr // x[n] index for real parts
    MOV x23, xzr
    MOV x24, xzr 
    
    
    MOV     x9, x1

    FDIV    s16, s2, s1 // s16 = 2pi / N
    
    // N in x1. 
    // k in x2.
    // n real in x23.
    // n im in x24.
    // sin and cos expects argument in s0 for float or d0 for double.

    // re = cos(2pi/N * kn)
    // im = -sin(2pi/N * kn)

    // re = cos(2pi/r2 * r3 * r12)
    // im = -sin(2pi/r2 * r3 * r12)









    // x0 offset. 
    
    // ADD     x0, x0, x10

    // load 4 floats to v0.
    
    // E
    // LD1     {v0.4s}, [x0] 
    


    cmp   x20, #0
    cinc  x20, x20, NE
    cinc  x20, x20, NE
    cinc  x20, x20, NE
    cinc  x20, x20, NE
    
    cmp x24, #0 
    cinc x24, x24, NE 
    

    

    // calculate 4 Fourier bins corresponding to offset x10 in x0, and store in v8 simd (real part)


mov x25, #1600
rb:
    cmp   x21, #0
    cinc  x21, x21, NE
    cinc  x21, x21, NE
    cinc  x21, x21, NE
    cinc  x21, x21, NE
    
    cmp x23, #0 
    cinc x23, x23, NE 
   
    // k * n 
    MUL     x13, x23, x2

    // k * n 
    SCVTF   s4, x13 

    // s0 = (k * n) * 2pi/n 
    FMUL    s0, s4, s16


    FCVT    d0, s0 
    sub     sp, sp, #32
    stp     x29, x30, [sp, #0]
    str     x1,       [sp, #16]
    mov     x29, sp
    
    mov     x28, x0 
    STR     S16, [SP, #24]
    BL      cos
    LDR     S16, [SP, #24]
    mov     x0, x28
    
    ldr     x1,       [sp, #16]
    ldp     x29, x30, [sp, #0]
    add     sp, sp, #32
    

    // get x[n]
    ADD     x0, x0, x21 

    // x[n]
    LDR     s7, [x0]

    FCVT    d7, s7


    // d0 = cos(2pikn/N) * x[n]
    FMUL    d0, d0, d7  

    FCVT    s0, d0 
    SUB     x0, x0, x21 
    
    // acumulate in s9 for real part
    fadd s9, s9, s0     



    ADD     x21, x21, 1
    ADD     x23, x23, 1
    
    sub x25, x25, #1      
    cmp x25, 0 
    b.ne rb
    


































mov x25, #1600
// imaginary
ib: 
    MUL     x13, x24, x2
    SCVTF   s4, x13 



    FMUL    s0, s4, s16
    FCVT    d0, s0 
    
    sub     sp, sp, #32
    stp     x29, x30, [sp, #0]
    str     x1,       [sp, #16]
    mov     x29, sp
    
    mov     x28, x0 
    STR     S16, [SP, #24]
    BL      sin
    LDR     S16, [SP, #24]
    mov     x0, x28
    
    ldr     x1,       [sp, #16]
    ldp     x29, x30, [sp, #0]
    add     sp, sp, #32
    

    ADD     x0, x0, x20

    // x[n]
    LDR     s7, [x0]


    FCVT    d7, s7

    FMUL    d0, d0, d7  
   
    FCVT    s0, d0 
    SUB     x0, x0, x20
    fadd s9, s9, s0 


    ADD     x20, x20, 1
    ADD     x14, x14, 1
    
    sub x25, x25, #1      
    cmp x25, #0 
    b.ne ib 
    


    // compute final magnitude.
    
    
    pep:
    b pep 
    


    //FINISH
    RET