#include <stdio.h>
#include <stdint.h>
#include <pulse/simple.h>
#include <pulse/error.h>

int main(void)
{
    // setup
    
    pa_sample_spec ss = {
    .format   = PA_SAMPLE_S16LE, // pcm 16 bit little endian
    .rate     = 44100,           // 44.1 kHz
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
    
    if(!mic) {
        printf("Debug 1, pa_simple_new()\n");
    }
    
    
    //int pa_simple_read(pa_simple *s, void *data, size_t bytes, int *error);
    
    // 4410 Samples per 0,1s window
    int16_t samples[4410];
    
    while(1) {
        int e = pa_simple_read(mic, samples, sizeof(samples), &err);
        // printf("OK\n");
        if(e < 0) {
            printf("Debug 2, pa_simple_read()\n");
        }
        
        
        // dft(&entry, &exit, 4410, frec)
        
    }

    
    pa_simple_free(mic);
    
}
