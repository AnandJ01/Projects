from SLLQueue import SLLQueue
from DLLDeque import DLLDeque


class MaxQueue(SLLQueue):
    def __init__(self):
        SLLQueue.__init__(self)
        self.max_deque = DLLDeque()

    def add(self, x : object):
        # my change
        SLLQueue.add(self, x)
        if self.max_deque.n > 0:
            if x > self.max_deque.get(0):
                self.new_max_deque = DLLDeque()
                self.new_max_deque.add_first(x)
                self.max_deque = self.new_max_deque
            else:
                size_of_max_deque = self.max_deque.n
                for i in range(size_of_max_deque-1,0,-1):
                    if x > self.max_deque.get(i):
                        self.max_deque.remove_last()
                    else:
                        break
                self.max_deque.add_last(x)
        else:
            self.max_deque.add_first(x)
        # end of my change
	    # """
	    # adds an element to the end of this max queue
	    # INPUT: x the element to add
	    # """
        #pass

    def remove(self) -> object:
        # my change
        if self.max_deque.n == 0: raise IndexError
        x = SLLQueue.remove(self)
        if(x == self.max_deque.get(0)):
            self.max_deque.remove_first()
        return x
        # end of my change
	    # """
	    # removes and returns the element at the head of the max queue
	    # """
        #pass

    def max(self) -> object:
        return self.max_deque.get(0)
	    # """
	    # returns the maximum element stored in the queue
	    # """
        #return self.max_deque.get(0)



# TESTER
# mq = MaxQueue()
# mq.add(3)
# print("Added:", 3)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(2)
# print("Added:", 2)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(1)
# print("Added:", 1)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(4)
# print("Added:", 4)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# r = mq.remove()
# print("Removed element:", r)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# r = mq.remove()
# print("Removed element:", r)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# r = mq.remove()
# print("Removed element:", r)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(8)
# print("Added:", 8)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(3)
# print("Added:", 3)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(5)
# print("Added:", 5)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(4)
# print("Added:", 4)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(1)
# print("Added:", 1)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")

# mq.add(6)
# print("Added:", 6)
# print("MaxQueue contents:", mq)
# print("Max Dequeu contents", mq.max_deque)
# print("Max element", mq.max(), "\n\n")


# while mq.size() > 0:
#     r = mq.remove()
#     print("Removed element:", r)
#     print("MaxQueue contents:", mq)
#     print("Max Dequeu contents", mq.max_deque)
#     if mq.size() > 0:
#         print("Max element", mq.max(), "\n\n")