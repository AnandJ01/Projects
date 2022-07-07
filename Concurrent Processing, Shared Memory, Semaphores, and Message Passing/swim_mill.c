/**
 * @file swim_mill.c
 * @author @AnandJ01
 * @brief The coordinator process, responsible for creating the fish process, 
 *        the pellet processes, and coordinating the termination of pellets. 
 *        Sets timer at the start of compution to 30 seconds, if compution has
 *        not finished by this time, swim_mill.c will kill all the children
 *        and grandchildren, then print out messages that it has done so and 
 *        then exits.
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
#include <wait.h>
#include <sys/sem.h>
#include <semaphore.h>
#include <fcntl.h>

pid_t fishPID;
pid_t pelletPID;

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

// Remove semaphore from memory
void UnlinkSemaphore(){
    if(sem_unlink(SEM_LOCATION)==-1){
        fprintf(stderr,"sem_unlink failed");
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

void DestroySharedMemory(){
    // destroy shared memory
    if(shmctl(shmid,IPC_RMID,NULL) == -1){
        fprintf(stderr,"shmctl failed");
        exit(1);
    }
}

void DisplySwimMill(){
    for(int i=0; i<100; i++){
        if(i%10 == 0 && i!=0){
            printf("\n");
        }
        printf("%c",(*swimMill)[i]);
    }
    printf("\n\n");
}

void TimeOut(){
    raise(SIGINT);
}

void Interrupt(){
    // kill pellet
    if(kill(pelletPID, SIGINT)==-1){
        printf("PID: %d Pellet Program couldn't be killed.\n", pelletPID);
    }
    // Kill fish
    if(kill(fishPID, SIGINT) == -1){
        printf("PID: %d Fish Program couldn't be killed.\n", fishPID);
    }

    wait(NULL);
    CloseSemaphore();
    UnlinkSemaphore();
    DetachSharedMemory();
    DestroySharedMemory();

    printf("PID: %d Program interrupted.\n", getpid());
    exit(0);
}

void Terminate(){
    // kill pellet
    if(kill(pelletPID, SIGINT)==-1){
        printf("PID: %d Pellet Program couldn't be killed.\n", pelletPID);
    }
    // Kill fish
    if(kill(fishPID, SIGINT) == -1){
        printf("PID: %d Fish Program couldn't be killed.\n", fishPID);
    }

    wait(NULL);
    CloseSemaphore();
    UnlinkSemaphore();
    DetachSharedMemory();
    DestroySharedMemory();

    printf("PID: %d Program terminated\n", getpid());
    exit(0);
}

int main(int argc, char * argv[]){
    
    printf("PID %d swim mill strated\n", getpid());

    signal(SIGINT, Interrupt);
    signal(SIGTERM, Terminate);
    signal(SIGALRM, TimeOut);
    alarm(31); // set max time to 30 seconds

    GetSharedMemory();
    AttachSharedMemory();
    OpenSeamphore();

    sem_wait(semaphore);
    // fill in swim mill
    for(int i=0; i<100;i++){
        (*swimMill)[i] = '~';
    }
    // place fish in the middle of last row
    (*swimMill)[95] = 'F';
    sem_post(semaphore);

    // create child processes
    fishPID = fork();
    if(fishPID == 0){
        execv("Fish", argv);
        exit(0);
    }
    else if(fishPID < 0){
        perror("Fork failed");
        exit(3);
    }

    pelletPID = fork();
    if(pelletPID == 0){
        execv("Pellet", argv);
        exit(0);
    }
    else if(pelletPID < 0){
        perror("Fork failed");
        exit(3);
    }

    for(int i = 30; i>=0; i--){
        printf("%d seconds remaining.\n", i);
        sleep(1);
        DisplySwimMill();
    }
    Terminate();

    return 0;

}

