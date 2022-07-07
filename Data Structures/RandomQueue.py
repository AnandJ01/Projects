import numpy as np
import random 
from ArrayQueue import ArrayQueue

class RandomQueue(ArrayQueue):
    def __init__(self):
        ArrayQueue.__init__(self)
            

    def remove(self) -> np.object :
        '''
            remove a random element
            You can call the method of the parent class using super(). e.g.
            super().remove()
        '''
        # todo
        # my change
        if self.n == 0 : raise IndexError 
        i = self.j+random.randint(0,self.n-1) % len(self.a)  # sets i to a random number between 0 - n-1 (both included)
        tempVar = self.a[self.j]
        self.a[self.j] = self.a[i]
        self.a[i] = tempVar
        x = ArrayQueue.remove(self)
        return x
        # end of my change
        #pass 

    # def add(self, d: np.object):
    #     ArrayQueue.add(self,d)

    # def testremove(self) -> np.object:
    #     x = ArrayQueue.remove(self)
    #     return x
     