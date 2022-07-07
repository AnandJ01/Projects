/**
 * @file pellet.c
 * @author @AnandJ01
 * @brief Each pellet process drops a pellet at a random distance from
 *        the fish, the pellet will start moving towards the fish with
 *        the flow of the river, the pellet moves in a straight line
 *        downstream.
 * @date due: 05-06-2022
 */

#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <sys/sem.h>
#include <semaphore.h>
#include <fcntl.h>

key_t key = 1111;
int shmid;
char (*swimMill)[100]; // 1D array pointer represents swim mill

#define SEM_LOCATION "/semaphore"
sem_t (*semaphore);

// create a semaphore if it already dosen't exist.
void OpenSeamphore(){
    if((semaphore = sem_open(SEM_LOCATION, O_CREAT, 0644,1)) == SEM_FAILED){
        fprintf(stderr, "sem_open failed");
        exit(1);
    }
}

// Close semaphore and deny access.
void CloseSemaphore(){
    if(sem_close(semaphore) == -1){
        fprintf(stderr,"sem_close failed");
        exit(1);
    }
}

void GetSharedMemory(){
    // get shared block -- create it if it dosen't exist
    shmid = shmget(key,sizeof(swimMill),0644|IPC_CREAT);
    if(shmid == -1){
        fprintf(stderr,"shmget failed");
        exit(1);
    }
}

void AttachSharedMemory(){
    // map the shared block into this process's memory
    // and get a pointer to it
    swimMill = shmat(shmid, NULL, 0);
    if(swimMill == (void *) -1){
        fprintf(stderr, "shmat failed");
        exit(1);
    }
}

void DetachSharedMemory(){
    // detach from shared memory
    if(shmdt(swimMill) == -1){
        fprintf(stderr,"shmdt failed");
        exit(1);
    }
}

// Handler for signal to interrupt
void interrupt(){
    // detach shared memory
    DetachSharedMemory();
    CloseSemaphore();
    printf("PID %d Pellet Killed from interrupt.\n",getpid());
    exit(0);
}

// Handler for signal to end
void terminate(){
    // detach shared memory
    DetachSharedMemory();
    CloseSemaphore();
    printf("PID %d Pellet Killed because program terminated.\n",getpid());
    exit(0);
}

// child thread to create pellets at random position
static void *child(void* ignored){
    // generate random number
    int randomNum;
    do{
        randomNum = rand()%80;
    }while((*swimMill)[randomNum] == 'o');

    // lock;
    sem_wait(semaphore);
    printf("Pellet %d was dropped at [%d,%d]\n", (int)pthread_self(), randomNum/10,randomNum%10);
    // unlock
    sem_post(semaphore);

    while(1){
        // put pellet in the swim mill
        (*swimMill)[randomNum] = 'o';
        
        // sleep for 1 sec and move pellet downstream
        sleep(1);
        randomNum += 10;

        if((*swimMill)[randomNum-10] != 'F'){
            sem_wait(semaphore);
            (*swimMill)[randomNum-10] = '~';
            sem_post(semaphore);
        }

        // check if the pellet was eaten or left swim mill
        // and write results to console
        sem_wait(semaphore);
        if(randomNum > 100){
            printf("Pellet %d wasn't eaten and left stream.\n", (int)pthread_self());
            sem_post(semaphore);
            break;
        }

        if((*swimMill)[randomNum] == 'F'){
            printf("Pellet %d was eaten.\n", (int)pthread_self());
            sem_post(semaphore);
            break;
        }
        sem_post(semaphore);
    }

    printf("Pellet %d is exiting.\n", (int)pthread_self());
    return 0;
}

int main(int argc, char *argv[]){

    printf("PID %d Pellet Started\n", getpid());

    // signal handling
    signal(SIGINT, interrupt);
    signal(SIGTERM, terminate);

    // get and attach shared memory
    GetSharedMemory();
    AttachSharedMemory();
    OpenSeamphore();

    // Initialize Pseudorandom number generator
    srand(time(0));

    // Create an array of threads to make multiple pellets
    pthread_t pellets[30];

    // Create threads to fill the pellets array
    int i;
    for(i=0; i<30; i++){
        // sleep random amount of time between 1-4
        sleep((rand()%4)+1);
        // Creeate new pellet thread
        pthread_create(&pellets[i], NULL, child, NULL);
    }

    // continue when the thread list is empty
    pthread_join(pellets[i],NULL);

    // Detach shared memory and exit
    DetachSharedMemory();
    printf("PID %d Pellet exited\n", getpid());
    return 0;
}