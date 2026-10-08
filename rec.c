#include <stdio.h>
#include <stdint.h>
#include <pulse/simple.h>
#include <pulse/error.h>

extern float adft(float* entry, int N, int K);

int main(void)
{
    // setup
    
    /* 
    pa_sample_spec ss = {
    .format   = PA_SAMPLE_S16LE, // pcm 16 bit little endian
    .rate     = 16000,           // 16 kHz
    .channels = 1                //mono
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
    
    if(!mic) {
        printf("Debug 1, pa_simple_new()\n");
    }
    
    
        
    
    //int pa_simple_read(pa_simple *s, void *data, size_t bytes, int *error);
    
    // 4410 Samples per 0,1s window
    */
    int16_t samples[1600];
    size_t c = sizeof(samples) / sizeof(samples[0]);
    
    float samples_float[c];
    
    /* while(1) {
        int e = pa_simple_read(mic, samples, sizeof(samples), &err);
        // printf("OK\n");
        if(e < 0) {
            printf("Debug 2, pa_simple_read()\n");
        } 
        */
        
    
        


        for (size_t i = 0; i < c; i++) {
         samples_float[i] = (float)samples[i];
        }
        
        printf("Ohyj C\n");
        
        adft(&samples_float[0], 1600, 1);
        
        printf("OK C\n");
        
   // }

    
    //;pa_simple_free(mic);
    
}
