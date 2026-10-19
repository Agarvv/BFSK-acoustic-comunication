#include <stdio.h>
#include <stdint.h>
#include <pulse/simple.h>
#include <pulse/error.h>

extern float adft(float* entry, int N, int K);
void parse();


int p = 0; 
int bit = 0;
    int byte = 0;
int rb = 0; 


int main(void)
{
// setup

pa_sample_spec ss = {
    .format   = PA_SAMPLE_S16LE, // pcm 16 bit little endian
    .rate     = 16000,           // 16 kHz
    .channels = 1                // mono
};

int err;

pa_simple *mic = pa_simple_new(
    NULL,
    "Idk",
    PA_STREAM_RECORD,
    NULL,
    "idk",
    &ss,
    NULL,
    NULL,
    &err
);

// printf("hello\n");

if (!mic) {
    printf("Debug 1, pa_simple_new()\n");
}

// int pa_simple_read(pa_simple *s, void *data, size_t bytes, int *error);

// 4410 Samples per 0,1s window

int16_t samples[1600];
size_t c = sizeof(samples) / sizeof(samples[0]);

float samples_float[c];




while (1) {
    int e = pa_simple_read(mic, samples, sizeof(samples), &err);

    // printf("OK\n");

    if (e < 0) {
        printf("Debug 2, pa_simple_read()\n");
    }

    for (size_t i = 0; i < c; i++) {
        samples_float[i] = (float)samples[i];
    }
    
    /* 
    for(int i = 0; i < 8; i++) {
        int bit = 0;
        int byte = 0; 
        
        
    
        byte = (byte | (bit << i));
        
       // printf("Preambulo: %d\n", byte); 
        
        if(byte == 0xAA) {
            parse();
        }
    
    
    } 
    */ 
    
    
    
    
    float r0 = adft(samples_float, 1600, 150);
    float r1 = adft(samples_float, 1600, 250);
    rb = rb + 1600; 
    
    if (r0 > r1) {
           bit = 0;
           printf("0");
           fflush(stdout);
        } else {
            bit = 1; 
            printf("1");
            fflush(stdout);
        }
        
    byte = (byte | (bit << p));
    p++; 
    printf("c: %d\n", p);
    if(p == 8 && byte == 0xAA) {
            if(rb == 64000) {
            parse();
            }
            printf("waiting preamble finish.\n");
    } 
    
    
    
    
    
    if(p == 8) {
       printf("Pre: %d\n", byte);
        byte = 0; 
    p = 0;
    
    }

    

    

}

pa_simple_free(mic);

}

void parse() {
    printf("Preamble OK. %d\n", rb);
    
    
    while(1);
}