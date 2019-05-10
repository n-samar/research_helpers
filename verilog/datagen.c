#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define SHUFFLE_NUM 4

/******************************************************************************/
static int comp(const void *c1, const void *c2)
{return *(uint32_t*)c1 - *(uint32_t*)c2;}

/******************************************************************************/
int main(int argc, char ** argv) {
    if (argc < 3) {
        printf("usage: ./datagen #num_ways #num_records_per_way seed\n");
        exit(1);
    }
    
    int ways            = atoi(argv[1]);
    int records_per_way = atoi(argv[2]);
    int seed = (argc==4) ? atoi(argv[3]) : 1; // random gen seed
    int n = ways * records_per_way;
    int i, j;
    printf("datagen %d way, %d records_per_way.\n", ways, records_per_way);

    uint32_t *buf;
    buf = calloc(n, sizeof(uint32_t));

    srand(seed);

    /******* generate keys *****/
    for (i=0; i<n; i++) buf[i] = rand();
    buf[0] = 0;   // Need a zero input
   
    
    /******* shuffle records *****/
    for (j=0; j< SHUFFLE_NUM; j++){
        for (i=0; i<n; i++){
            int idx1 = i;
            int idx2 = rand() % n;
            
            uint32_t tmp = buf[idx1];
            buf[idx1] = buf[idx2];
            buf[idx2] = tmp;
        }
    }
    
    /*******  partially sorting & generate data.txt *****/
    {
      char data_filename[80];
      strcpy(data_filename, "data_");
      strcat(data_filename, argv[1]);
      strcat(data_filename, "_");
      strcat(data_filename, argv[2]);
      strcat(data_filename, ".txt");
      FILE *dat = fopen(data_filename, "w+");
        
      for (i=0; i<ways; i++){
	qsort(buf+i*records_per_way,
	      records_per_way, sizeof(uint32_t), comp);
	buf[i*records_per_way] = 0;
      }
      for (i=0; i<n; i++){
	fprintf(dat, "%08x\n", buf[i]); 
      }
      fprintf(dat, "%08x\n", 0);   // Add trailing zero for testing convenience
      fclose(dat);
    }

    /******* generate ans.txt *****/
    {
      qsort(buf, n, sizeof(uint32_t), comp);
      char ans_filename[80];
      strcpy(ans_filename, "ans_");
      strcat(ans_filename, argv[1]);
      strcat(ans_filename, "_");
      strcat(ans_filename, argv[2]);
      strcat(ans_filename, ".txt");            
      FILE *ans = fopen(ans_filename, "w+");
      for (i=0; i<n; i++){
	fprintf(ans, "%08x\n", buf[i]);
      }
      fclose(ans);
    }    
    
    return 0;
}
