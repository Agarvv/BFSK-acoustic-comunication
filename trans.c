#include <stdio.h> 
#include <math.h>
#include <stdint.h>

typedef struct {
    char     riff[4];           // "RIFF"
    uint32_t file_size;
    char     wave[4];           // "WAVE"

    char     fmt[4];            // "fmt "
    uint32_t fmt_size;
    uint16_t audio_format;      // 1 = PCM
    uint16_t channels;          // 1 = mono
    uint32_t sample_rate;       // 44100 Hz
    uint32_t byte_rate;
    uint16_t block_align;
    uint16_t bits_per_sample;   // 16 bits

    char     data[4];            // "data"
    uint32_t data_size;
} WavHeader;



int main(int argc, char** argv) {
 // get ASCII information to be converted to aucustic information.
 FILE *file = fopen("m.txt", "r");
 if(file == NULL) {
     perror("Error in File Creation");
 }
 
 fseek(file, 0, SEEK_END);
 long fsize = ftell(file); 
 rewind(file); 
 
 char buff[fsize + 1]; 
 
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);


 fread(buff, sizeof(buff), fsize, file); 
 buff[fsize] = '\0';
 
 printf("Buff: %s\n", buff);
 
 
 // create WAV file 
 FILE *wav = fopen("aucustic.wav", "w+");
 if(wav == NULL) {
     perror("Error in Polla File Creation");
 }
 
 WavHeader header = {
    .riff = {'R', 'I', 'F', 'F'},
    .file_size = 0,
    .wave = {'W', 'A', 'V', 'E'},

    .fmt = {'f', 'm', 't', ' '},
    .fmt_size = 16,
    .audio_format = 1,
    .channels = 1,
    .sample_rate = 44100,
    .byte_rate = 44100 * 1 * 16 / 8,
    .block_align = 1 * 16 / 8,
    .bits_per_sample = 16,

    .data = {'d', 'a', 't', 'a'},
    .data_size = 0
};

fwrite(&header, sizeof(header), 1, wav);
          

 
 // 2500hz means 1 
 // 2000hz means 0
 
 // f(t) = sin((2pi) * (2000 | 2500) * (n/s_rate))
 
 double n = 0; 
 unsigned int total_samples = 0;
 unsigned int data_size = 0;
 for(int i = 0; i < fsize; i++) {
     printf("fsize: %lo\n", fsize);
     unsigned char c = buff[i]; 

     n = n/header.sample_rate; 
     
     double samples_per_bit = 0.1 * header.sample_rate;
     
         
         
         for(int i = 0; i < 8; i++) {
             
             // printf("Bit\n");
             
             
             for (double d = samples_per_bit; d > 0; d--) {
             
             unsigned char m = ((c >> i) & 1);
             
             
             
             double sample = sin((2 * M_PI) * (m ? 1500.0 : 2500.0) * (n/header.sample_rate));
             
             int16_t pcm = (int16_t)(sample * 32767);
             
             fwrite(&pcm, sizeof(pcm), 1, wav); 
             data_size += sizeof(pcm);
             
             //printf("%d\n", pcm);
             
             n+=1;
             
                } 
             
             total_samples+= samples_per_bit;
         }
         
          
          // data_size = 16 * samples_per_bit;
          header.data_size = data_size;
          printf("%u Data Size.\n", header.data_size); 
          
          
          
          // end of polla 
 
 

      
 }
 
 header.data_size = data_size;
         header.file_size = data_size + 36;

          fseek(wav, 0, SEEK_SET);
          fwrite(&header, sizeof(header), 1, wav);
          
  fclose(wav);
  printf("Success\n");
 
 return 0;
}
