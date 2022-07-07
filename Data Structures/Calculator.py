import numpy as np
import ArrayStack
import BinaryTree
import ChainedHashTable
import DLList
import operator

class Calculator:
    def __init__(self) :
        self.dict = ChainedHashTable.ChainedHashTable(DLList.DLList)

    def set_variable(self, k :str, v : float) :
        self.dict.add(k,v)
        
    def matched_expression(self, s : str) -> bool :
        # todo
        # my change
        array = ArrayStack.ArrayStack()
        for char in s:
            if char == '(':
                array.push(1)
            elif char == ')':
                try:
                    x = array.pop()
                except IndexError:
                    return 0

        if array.size() == 0:
            return 1
        else:
            return 0
        # end of my change
        #pass 

    def build_parse_tree(self, exp : str) ->str:
        # todo
        pass 

    def _evaluate(self, root):
        op = { '+':operator.add, '-':operator.sub, '*':operator.mul, '/':operator.truediv}
        # todo
        pass 

    def evaluate(self, exp):
        parseTree = self.build_parse_tree(exp)
        return self._evaluate(parseTree.r)
        
