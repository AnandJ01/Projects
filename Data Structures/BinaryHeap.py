import numpy as np
from Interfaces import Queue



def left(i : int):
    # my change
    return 2*i+1
    # end of my change
    # todo
    #pass 

def right(i: int):
    # my change
    return 2*(i+1)
    # end of my change
    # todo
    #pass 

def parent(i : int):
    # my change
    return (i-1)//2
    # end of my change
    # todo
    #pass 

class BinaryHeap(Queue):
    def __init__(self):
        self.a = self.new_array(1)
        self.n = 0

    def new_array(self, n: int) ->np.array:
        return np.zeros(n, np.object)

    def resize(self):
        # my change
        b = self.new_array(max(1,self.n*2))
        for i in range(0,self.n,1):
            b[i] = self.a[i]
        self.a = b
        # end of my change
        # todo
        #pass 

    def add(self, x : object):
        # my change
        if len(self.a) == self.n: self.resize()
        self.a[self.n] = x
        self.n +=1
        self.bubble_up(self.n-1)
        # end of my change
        # todo
        #pass 

    def bubble_up(self, i):
        # my change
        if i<0 or i>=self.n: raise IndexError
        p_idx = parent(i)
        while i>0 and self.a[i]<self.a[p_idx]:
            temp = self.a[i]
            self.a[i] = self.a[p_idx]
            self.a[p_idx] = temp
            i = p_idx
            p_idx = parent(i)
        # end of my change
        # todo
        #pass 

    def remove(self):
        # my change
        if self.n==0:raise IndexError
        temp = self.a[0]
        self.a[0] = self.a[self.n-1]
        self.n -=1
        self.trickle_down(0)
        if len(self.a)>=3*self.n: self.resize()
        return temp
        # end of my change
        # todo
        #pass 

    def trickle_down(self, i):
        # my change
        while i>=0:
            s = -1
            r_idx = right(i)
            l_idx = left(i)
            if(r_idx<self.n and self.a[r_idx]<self.a[i]):
                if self.a[l_idx] < self.a[r_idx]: s = l_idx
                else: s = r_idx
            else:
                if l_idx<self.n and self.a[l_idx]<self.a[i]: s = l_idx
            if s>=0:
                temp = self.a[i]
                self.a[i] = self.a[s]
                self.a[s] = temp
            i = s
        # end of my change
        # todo
        #pass 

    def find_min(self):
        if self.n == 0: raise IndexError()
        return self.a[0]

    def size(self) -> int:
        return self.n

    def __str__(self):
        s = "["
        for i in range(0, self.n):
            s += "%r" % self.a[i]
            if i  < self.n-1:
                s += ","
        return s + "]"


def __main__():
    test = BinaryHeap()
    test.add(5)
    test.add(11)
    test.add(10)
    test.add(33)
    test.add(34)
    test.add(21)
    test.add(20)
    test.add(99)
    test.add(6)
    # print(test)
    # test.remove()
    # test.remove()
    # test.remove()
    print(test)

if __name__ == '__main__':
    __main__()
