#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define NUM_THREADS 4
sem_t mutex;
void *PrintHello(void *threadid) {
   long tid;
   tid = (long)threadid;
   //wait
    sem_wait(&mutex);
    printf("Hello! Thread ID, %d\n", tid);
  
    //critical section
    sleep(4);
      
    //signal
    printf("\nJust Exiting...\n\n");
   sem_post(&mutex);
   
   pthread_exit(NULL);
}
void *PrintWorld(void *threadid) {
   long tid;
   tid = (long)threadid;
   //wait
    sem_wait(&mutex);
    printf("World! Thread ID, %d\n", tid);
  
    //critical section
    sleep(4);
      
    //signal
    printf("\nJust Exiting...\n\n");
    sem_post(&mutex);
   
   pthread_exit(NULL);
}

int main () {
   pthread_t threads[NUM_THREADS];
   int rc;
   int rb;
   int i;
   sem_init(&mutex, 0, 1);
   for( i = 0; i < NUM_THREADS; i++ ) {
     if (NUM_THREADS)
      rc = pthread_create(&threads[i], NULL, PrintHello, (void *)i);
      sleep(2);
      rb = pthread_create(&threads[i], NULL,  PrintWorld, (void *)i);
      pthread_join(threads[i],NULL);
      if (rc) {
         printf("Error:unable to create thread, %d\n", rc);
         exit(-1);
      }
      if (rb) {
         printf("Error:unable to create thread, %d\n", rc);
         exit(-1);
      }
   }
   sem_destroy(&mutex);
   pthread_exit(NULL);
}
