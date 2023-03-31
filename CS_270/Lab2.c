#include <stdlib.h>
#include <pthread.h>

#define NUM_THREADS 4
void *PrintHello(void *threadid) {
   long tid;
   tid = (long)threadid;
   printf("Hello! Thread ID, %d\n", tid);
   pthread_exit(NULL);
}
void *PrintWorld(void *threadid) {
   long tid;
   tid = (long)threadid;
   printf("World! Thread ID, %d\n", tid);
   pthread_exit(NULL);
}

int main () {
   pthread_t threads[NUM_THREADS];
   int rc;
   int rb;
   int i;
   for( i = 0; i < NUM_THREADS; i++ ) {
     if (NUM_THREADS)
      rc = pthread_create(&threads[i], NULL, PrintHello, (void *)i);
      rb = pthread_create(&threads[i], NULL,  PrintWorld, (void *)i);
      if (rc) {
         printf("Error:unable to create thread, %d\n", rc);
         exit(-1);
      }
     if (rb) {
         printf("Error:unable to create thread, %d\n", rc);
         exit(-1);
      }
   }
   pthread_exit(NULL);
}