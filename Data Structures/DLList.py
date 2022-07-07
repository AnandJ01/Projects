from Interfaces import List
import numpy as np


class DLList(List):
    class Node:
        def __init__(self, x : np.object) :
            self.next = None
            self.prev = None
            self.x = x

    def __init__(self) :
        self.dummy = DLList.Node("")
        self.dummy.next = self.dummy
        self.dummy.prev = self.dummy
        self.n = 0
   
    def get_node(self, i : int) -> Node:
        # todo
        # my change
        if i<0 or i>self.n: return None
        if i< self.n/2:
            p = self.dummy.next
            for k in range(0,i,1):
                p = p.next
        else:
            p = self.dummy
            for k in range(0, self.n-i,1):
                p = p.prev
        return p
        # end of my change
        #pass 
        
    def get(self, i) -> np.object:
        # todo
        # my change
        if i<0 or i>=self.n: raise IndexError
        return self.get_node(i).x
        # end of my change
        #pass 

    def set(self, i : int, x : np.object) -> np.object:
        # todo
        # my change
        if i<0 or i>=self.n: raise IndexError
        u = self.get_node(i)
        y = u.x
        u.x = x
        return y
        # end of my change
        #pass 

    def add_before(self, w : Node, x : np.object) -> Node:
        # todo
        # my change
        if w==None: raise ValueError
        u = self.Node(x)
        u.prev = w.prev
        u.next = w
        u.next.prev = u
        u.prev.next = u
        self.n+=1
        return u
        # end of my change
        #pass 
            
    def add(self, i : int, x : np.object)  :
        # todo
        # my change
        if i<0 or i>self.n: raise IndexError
        return self.add_before(self.get_node(i),x)
        # end of my change
        #pass 

    def _remove(self, w : Node) :
       # todo
       # my change
       w.prev.next = w.next
       w.next.prev = w.prev
       self.n -= 1
       # end of my change
       # pass 
    
    def remove(self, i :int) :
        if i < 0 or i >= self.n:  raise IndexError
        w = self.get_node(i)
        self._remove(w)
        return w


    def size(self) -> int:
        return self.n

    def append(self, x : np.object)  :
        self.add(self.n, x)

    def isPalindrome(self) -> bool :
        # todo
        # my change 
        H = self.dummy.next
        T = self.dummy.prev
        for j in range(0,int(self.n/2),1):
            if(H.x == T.x):
                H = H.next
                T = T.prev
            else:
                return False
        return True
        # end of my change
        #pass

    # my change
    def reverse(self):
        H = self.dummy.next
        T = self.dummy.prev
        curr = self.dummy.next
        previ = self.dummy
        temp = curr.next

        while(curr != self.dummy):
            curr.next = previ
            curr.prev = temp
            previ = curr
            curr = temp
            temp = temp.next
        self.dummy.next = T
        self.dummy.prev = H
    # end of my change


    def __str__(self):
        s = "["
        u = self.dummy.next
        while u is not self.dummy:
            s += "%r" % u.x
            u = u.next
            if u is not None:
                s += ","
        return s + "]"


    def __iter__(self):
        self.iterator = self.dummy.next
        return self

    def __next__(self):
        if self.iterator != self.dummy:
            x = self.iterator.x
            self.iterator = self.iterator.next
        else:
             raise StopIteration()
        return x
