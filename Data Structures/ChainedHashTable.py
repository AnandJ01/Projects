from Interfaces import Set
from DLList import DLList
import numpy as np

class ChainedHashTable(Set):
    class Node() :
        def __init__(self, key, value) :
            self.key = key
            self.value = value

    def __init__(self, dtype=DLList) :
        self.dtype = dtype
        self.d = 1
        self.t = self.alloc_table(2**self.d)
        self.z = 193759204821
        self.w = 31
        self.n = 0

    def alloc_table(self, n: int):
        t = np.zeros(n, dtype= np.object)
        for i in range(n):
            t[i] = self.dtype()
        return t

    def _hash(self, key : int) -> int :
        return self.z * hash(key) % (2**self.w) >> (self.w - self.d) 

    def size(self) -> int:
        return self.n
        
    def find(self, key : object) -> object :
        # todo
        # my change
        h = self._hash(key)
        for i in range(0, len(self.t[h])):
            if self.t[h][i].key == key: return self.t[h][i].value
        return None
        # end of my change
        #pass 
        
    def add(self, key : object, value : object) :
        # todo
        # my change
        if self.find(key) != None: return False
        if(self.n == len(self.t)): self.resize()
        hash_value = self._hash(key)
        self.t[hash_value].append(self.Node(key, value))
        self.n += 1
        # end of my change
        #pass 


    def remove(self, key : int)  -> object:
        # todo
        # my change
        if self.find(key) == None: return None
        hash_value = self._hash(key)
        temp = None
        for i in range(0, len(self.t[hash_value]), 1):
            if self.t[hash_value][i].key == key:
                temp = self.t[hash_value].remove(i)
                self.n -= 1
                break
        if len(self.t) > 3*self.n: self.resize()
        return temp
        # end of my change
        #pass 
    
    def resize(self):
        # todo
        # my change
        if self.n == 2**self.d: self.d += 1
        elif 2**self.d >= 3*self.n: self.d -= 1
        temp = self.alloc_table(2**self.d)
        for i in range(0,len(self.t),1):
            for j in range(0,self.t[i].size(),1):
                current_element = self.t[i].get(j)
                h = self._hash(current_element.key)
                temp[h].append(current_element)
        self.t = temp
        # end of my change
        #pass 


    # def __str__(self):
    #     s = "["
    #     for i in range(len(self.t)):
    #         for j in range(len(self.t[i])):
    #             k = self.t[i][j]
    #             s += str(k.key)
    #             s += ":"
    #             s += str(k.value)
    #             s += ";"
    #     return s + "]"

    def __str__(self):
        s = "\n"
        for i in range(len(self.t)):
            s += str(i) + " : "
            for j in range(len(self.t[i])):
                k = self.t[i][j]  # jth node at ith list
                s += "(" + str(k.key) + ", " + str(k.value) + "); "

            s += "\n"
        return s


# def __main__():
#     has = ChainedHashTable()
#     has.add(23,"A")
#     has.add(15,"B")
#     has.add(11,"c")
#     has.remove(23)
#     # has.remove(15)
#     has.add(10,"D")
#     has.add(9,"E")
#     # has.add(12,"A")
#     has.add(16,"F")
#     has.add(21,"G")
#     has.remove(21)
#     has.remove(10)
#     has.remove(16)
#     # has.remove(11)
#     # has.remove(9)
#     has.remove(15)
#     # has.remove(10)
#     # has.add(15,"b")

#     print(has.__str__())

# if __name__ == '__main__':
#     __main__()

