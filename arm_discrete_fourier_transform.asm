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
    add     x10, x10, :lo12:DOS_PI

    ldr     s2, [x10] // 2pi in s2
    scvtf s1, r2 // N

    mov x12, xzr 
    mov x10, xzr 
    mov x9, x2
    
    fdiv    s0, s2, s1      // s0 = 2pi / N
    
    // N in r2. 
    // k in r3.
    // n in r12.
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
        
        // calculate 4 Fourier bins corresponding to offset x10 in x0, and store in v1 simd.
        
        // k * n 
        mul x13, x12, x3
        
        // k * n 
        scvtf s4, x13 
        
        // s0 = (k * n) * 2pi/n 
        
        fmul    s0, s4, s1  
        bl cos
        
        

        

        
        
        
        
        
        
        
        // prepare x[n] v2 simd register 
        
        // multiply (v0 + v1) * v2.
        
        // increment x0 offset.
        add x10, x10, 4
        add x12, x12, 1
        
        
        b loop 
        
    
    end:
        ret 

    