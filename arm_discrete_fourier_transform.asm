.section .rodata

msg:
    .ascii "polla\n"
    
TWO_PI:
    .float 6.2831853072

.section .text
.global _start

_start:
    // write(1, msg, 13)

    mov x0, #1              // fd = stdout
    adr x1, msg             
    mov x2, #13             // len
    mov x8, #64             // syscall: write
    svc #0                  // supervisor call 0

    // exit(0)
    
    
    
    

    mov x0, #0              // exit 0
    mov x8, #93             // syscall: exit
    svc #0
    
adft:

    adrp    x10, TWO_PI
    add     x10, x10, :lo12:TWO_PI

    ldr     s2, [x10] // 2pi in s2
    scvtf s1, r2 // N

    mov x12, xzr 
    mov x10, xzr 
    mov x20, xzr // x[n] index for imaginary parts
    mov x21, xzr // x[n] index for real parts
    mov x9, x2
    
    fdiv    s0, s2, s1      // s0 = 2pi / N
    
    // N in x2. 
    // k in x3.
    // n in x12.
    // sin and cos expects argument in s0 for float or d0 for double.
    
    // re = cos(2pi/N * kn)
    // im = -sin(2pi/N * kn)
    
    // re = cos(2pi/r2 * r3 * r12)
    // im = -sin(2pi/r2 * r3 * r12)
    
    // loop N.
    loop:
    
        // substract N
        sub x9, x9, 1
        cmp x9, 0 
        // if equal 0, end loop.
        
        
        b.eq end 
        
        // x0 offset. 
        add x0, x0, x10
        
        // load 4 floats to v0.
        ld1 {v0.4s}, [x0]
        
        // calculate 4 Fourier bins corresponding to offset x10 in x0, and store in v1 simd (real part)
        
        // k * n 
        mul x13, x12, x3
        
        // k * n 
        scvtf s4, x13 
        
        // s0 = (k * n) * 2pi/n 
        
        fmul    s0, s4, s1  
        
        
        fcvt d0, s0 
        bl cos
        
        // get x[n]
        add x0, x0, x21 
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        
        // d0 = cos(2pikn/N) * x[n]
        fmul d0, d7 
        
        
        fcvt s0, d0 
        ins v1.s[0], v0.s[0]
        
        
        
        
        add x21, x21, 1
        add x12, x12, 1
        mul x13, x12, x3
        scvtf s4, x13 
        
        
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl cos
        
        add x0, x0, x21 
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x21 
        
        ins v1.s[1], v0.s[0]
        
        
        add x21, x21, 1
        add x12, x12, 1
        mul x13, x12, x3
        scvtf s4, x13 
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl cos
        
        add x0, x0, x21 
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x21
        
        
        ins v1.s[2], v0.s[0]
        
        
        
        add x21, x21, 1
        
        add x12, x12, 1
        mul x13, x12, x3
        scvtf s4, x13 
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl cos
        
        add x0, x0, x21 
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x21
        
        ins v1.s[3], v0.s[0]
        
         
        // compute 4 Fourier bins corresponding to offset x10 in x0, and store in v2 simd (imaginary part)
        
        add x12, x12, 1
        
        mul x13, x12, x3
        scvtf s4, x13 
        
        
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl sin
        
        add x0, x0, x20
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        ins v2.s[0], v0.s[0]
        
        
        
        
        add x20, x20, 1
        add x12, x12, 1
        
        mul x13, x12, x3
        scvtf s4, x13 
        
        
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl sin
        
        add x0, x0, x20
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x20
        
        
        ins v2.s[1], v0.s[0]
        
        add x20, x20, 1
        add x12, x12, 1
        
        mul x13, x12, x3
        scvtf s4, x13 
        
        
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl sin
        
        add x0, x0, x20
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x20
        
        
        ins v2.s[2], v0.s[0]
        
        
        
        add x20, x20, 1
        add x12, x12, 1
        
        mul x13, x12, x3
        scvtf s4, x13 
        
        
        
        fmul    s0, s4, s1  
        fcvt d0, s0 
        bl sin
        
        add x0, x0, x20
        
        // x[n]
        mov s7, [x0]
        
        fcvt s7, d7 
        fmul d0, d7 
        
        sub x0, x0, x20
        
        
        ins v2.s[3], v0.s[0]
        
        // with imaginary part in v2 and real part in v1, add all of them. acumulate in s9 and s10.
        
        faddp s9, v1.4s,v1.4s 
        faddp s10, v2.4s,v2.4s 
        
        
        
        // increment x0 offset.
        add x10, x10, 4
        
        
        b loop 
        
    
    end:
        // compute complex number magnitude.
        
        // return it to C.
        ret 

    