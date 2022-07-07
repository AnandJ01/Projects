/**
 * @file fish.c
 * @author @AnandJ01
 * @brief The fish process sees the pellet as it is dropped and moves one
 *        unit left or right
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
    printf("PID %d Fish Killed from interrupt.\n",getpid());
    exit(0);
}

// Handler for signal to end
void terminate(){
    // detach shared memory
    DetachSharedMemory();
    CloseSemaphore();
    printf("PID %d Fish Killed because program terminated.\n",getpid());
    exit(0);
}

int main(int argc, char *argv[]){

    printf("PID %d Fish strated \n", getpid());

    // signal handling
    signal(SIGINT, interrupt);
    signal(SIGTERM, terminate);

    // get and attach shared memory
    GetSharedMemory();
    AttachSharedMemory();
    OpenSeamphore();

    int fishPosition = 5;
    int pellets[10] = {0};
    int closestPellet = 11;
    while(1){
        // clear pellets array;
        for (int i = 0; i< 10; i++){
            pellets[i] = 0;
        }
        // find pellets and store position in pellets array
        for (int i = 0; i< 100; i++){
            if((*swimMill)[i]=='o'){
                pellets[i%10] = 1;
            }

        }
        // find closest pellet to the fish
        for(int i = 0; i<10;i++){
            if(pellets[i]>0){
                if(abs(i-fishPosition)<abs(fishPosition-closestPellet)){
                    closestPellet = i;
                }
            }
        }

        // move fish to the right
        if(closestPellet > fishPosition && closestPellet< 11){
            sem_wait(semaphore);
            (*swimMill)[fishPosition+90] = '~';
            fishPosition++;
            (*swimMill)[fishPosition+90] = 'F';
            sem_post(semaphore);
        }
        // move fish to the left
        else if(closestPellet<fishPosition && closestPellet < 11){
            sem_wait(semaphore);
            (*swimMill)[fishPosition+90] = '~';
            fishPosition--;
            (*swimMill)[fishPosition+90] = 'F';
            sem_post(semaphore);
        }
        // don't move fish if the pellet is in the same column as the fish
        closestPellet = 11;
        sleep(1);        

    }
}
