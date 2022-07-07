import numpy as np
from Interfaces import Queue

class ArrayQueue(Queue):
    def __init__(self):
        self.n = 0
        self.j = 0
        self.a = self.new_array(1)
        
    def new_array(self, n: int) ->np.array:
        return np.zeros(n, np.object)
    
    def resize(self):
        '''
            Resize the array
        '''
        # my change
        b = self.new_array(max(1,self.n*2))
        for i in range(0,self.n,1):
            b[i] = self.a[(self.j+i) % len(self.a)]
        self.a = b
        self.j = 0
        # end of my change
        #pass 

    # my change
    def get(self, i: int) -> np.object:
        if i < 0 or i >= self.n: raise IndexError()
        return self.a[i]
    # end of my change

    
    def add(self, x : np.object) :
        '''
            shift all j > i one position to the right
            and add element x in position i
        '''
        # my change
        if self.n+1 > len(self.a): self.resize()
        self.a[(self.j+self.n) % len(self.a)] = x
        self.n += 1
        # end of my change
        #pass 

    def remove(self) -> np.object :
        '''
            remove the first element in the queue
        '''
        # my change
        if self.n == 0: raise IndexError
        x = self.a[self.j]
        self.j = (self.j+1) % len(self.a)
        self.n -= 1
        if len(self.a) >= 3*self.n: self.resize()
        return x
        # end of my change
        #pass 

    def size(self) :
        return self.n

    def __str__(self):
        s = "["
        for i in range(0, self.n):
            s += "%r" % self.a[(i + self.j) % len(self.a)]
            if i  < self.n-1:
                s += ","
        return s + "]"

    def __iter__(self):
        self.iterator = 0
        return self

    def __next__(self):
        if self.iterator < self.n:
            x = self.a[self.iterator]
            self.iterator +=1
        else:
             raise StopIteration()
        return x
