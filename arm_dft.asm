.section .rodata

msg:
.ascii "polla\n"

TWO_PI:
.float 6.2831853072


.section .text
.global adft
// .global main 
.extern sin
.extern cos


adft:
    ADRP    x10, TWO_PI
    ADD     x10, x10, :lo12:TWO_PI

    
    
    LDR     s2, [x10] // 2pi in s2
    SCVTF   s1, x1 // N

    MOV     x12, xzr 
    MOV     x10, xzr 
    MOV     x20, xzr // x[n] index for imaginary parts
    MOV     x21, xzr // x[n] index for real parts
    MOV     x9, x1

    FDIV    s0, s2, s1 // s0 = 2pi / N
    
    // N in x1. 
    // k in x2.
    // n in x12.
    // sin and cos expects argument in s0 for float or d0 for double.

    // re = cos(2pi/N * kn)
    // im = -sin(2pi/N * kn)

    // re = cos(2pi/r2 * r3 * r12)
    // im = -sin(2pi/r2 * r3 * r12)

    // loop N.
    
    
loop:

   pe:
    B pe 
    
    // substract N
    SUB     x9, x9, 1
    CMP     x9, 0 

    // if equal 0, end loop.
    B.EQ    end 

    // x0 offset. 
    
    ADD     x0, x0, x10

    // load 4 floats to v0.
    
    // E
    // LD1     {v0.4s}, [x0] 
    
    

    // calculate 4 Fourier bins corresponding to offset x10 in x0, and store in v1 simd (real part)

    // k * n 
    MUL     x13, x12, x2

    // k * n 
    SCVTF   s4, x13 

    // s0 = (k * n) * 2pi/n 

    FMUL    s0, s4, s1 


    FCVT    d0, s0 
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      cos
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    

    // get x[n]
    ADD     x0, x0, x21 

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 

    // d0 = cos(2pikn/N) * x[n]
    FMUL    d0, d0, d7  

    FCVT    s0, d0 
    INS     v1.s[0], v0.s[0]


    ADD     x21, x21, 1
    ADD     x12, x12, 1
    MUL     x13, x12, x2
    SCVTF   s4, x13 


    FMUL    s0, s4, s1 
    FCVT    d0, s0
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      cos
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    

    ADD     x0, x0, x21 

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 
    FMUL    d0, d0, d7    

    SUB     x0, x0, x21 

    INS     v1.s[1], v0.s[0]


    ADD     x21, x21, 1
    ADD     x12, x12, 1
    MUL     x13, x12, x2
    SCVTF   s4, x13 

    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      cos
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    

    ADD     x0, x0, x21 

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 
    FMUL    d0, d0, d7    // d0 = d0 * d7


    SUB     x0, x0, x21


    INS     v1.s[2], v0.s[0]



    ADD     x21, x21, 1

    ADD     x12, x12, 1
    MUL     x13, x12, x2
    SCVTF   s4, x13 

    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      cos
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    
    
    
    ADD     x0, x0, x21 

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 
    FMUL    d0, d0, d7  


    SUB     x0, x0, x21

    INS     v1.s[3], v0.s[0]


    // compute 4 Fourier bins corresponding to offset x10 in x0, and store in v2 simd (imaginary part)

    ADD     x12, x12, 1

    MUL     x13, x12, x2
    SCVTF   s4, x13 



    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      sin
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    

    ADD     x0, x0, x20

    // x[n]
    LDR     s7, [x0]


    FCVT    s7, d7 
    FMUL    d0, d0, d7  

    INS     v2.s[0], v0.s[0]




    ADD     x20, x20, 1
    ADD     x12, x12, 1

    MUL     x13, x12, x2
    SCVTF   s4, x13 



    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      sin
    mov x0, x28
    
    ldp x29, x30, [sp], 16

    ADD     x0, x0, x20

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 
    FMUL    d0, d0, d7  

    SUB     x0, x0, x20


    INS     v2.s[1], v0.s[0]

    ADD     x20, x20, 1
    ADD     x12, x12, 1

    MUL     x13, x12, x2
    SCVTF   s4, x13 



    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      sin
    mov x0, x28
    
    ldp x29, x30, [sp], 16
    
    
    ADD     x0, x0, x20

    // x[n]
    LDR     s7, [x0]


    FCVT    s7, d7 
    FMUL    d0, d0, d7  

    SUB     x0, x0, x20


    INS     v2.s[2], v0.s[0]



    ADD     x20, x20, 1
    ADD     x12, x12, 1

    MUL     x13, x12, x2
    SCVTF   s4, x13 



    FMUL    s0, s4, s1 
    FCVT    d0, s0 
    
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x28, x0 
    BL      sin
    mov x0, x28
    
    ldp x29, x30, [sp], 16


    ADD     x0, x0, x20

    // x[n]
    LDR     s7, [x0]

    FCVT    s7, d7 
    FMUL    d0, d0, d7  


    SUB     x0, x0, x20


    INS     v2.s[3], v0.s[0]

    // with imaginary part in v2 and real part in v1, add all of them. acumulate in s9 and s10.

    FADDP   v9.4s, v1.4s, v1.4s
    FADDP   v9.4s, v9.4s, v9.4s

    FADDP   v10.4s, v2.4s, v2.4s
    FADDP   s10, v10.2s
     

    // increment x0 offset.
    ADD     x10, x10, 4

    
    B loop 


end:
    // compute complex number magnitude.
    FSUB    s9, s9, s10 
    FSQRT   s0, s9
    
    


    // return it to C.
    RET