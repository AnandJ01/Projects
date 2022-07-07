import ArrayQueue
tarvesalList = []
class BinaryTree:
    class Node:
        def __init__(self, x : object, v = None) :
            self.parent = self.left = self.right = None
            self.x = x
            self.v = v

        def set_key(self, x) :
            self.x = x

        def set_val(self, v):
            self.v = v

        def insert_left(self) :
            self.left = BinaryTree.Node('') 
            self.left.parent = self
            return self.left

        def insert_right(self) :
            self.right = BinaryTree.Node('')
            self.right.parent = self
            return self.right

        def __str__(self):
            if self.v is None:
                return str(self.x)
            return f"({self.x}, {self.v})"

    def __init__(self) : 
        self.r = None

    def depth(self, u : Node) -> int:
        # todo
        # my change
        if u == None: return 0
        current = u
        d=0
        while current != self.r:
            current = current.parent
            d = d+1
        return d
        # end of my change
        #pass

    def _size(self, u : Node) -> int:
        # todo
        # my change
        if u is None:
            return 0
        return 1+self._size(u.left)+self._size(u.right)
        # end of my change
        #pass

    def size(self) -> int:
        return self._size(self.r)

    def size2(self) -> int:
        # todo
        # my change
        u = self.r
        prev = None
        n = 0
        while u!=None:
            if prev == u.parent:
                n = n+1
                if u.left != None: next = u.left
                elif u.right != None: next = u.right
                else: next = u.parent
            elif prev == u.left:
                if u.right != None: next = u.right
                else: next = u.parent
            else:
                next = u.parent
            prev = u
            u = next
        return n
        # end of my change
        #pass

    def _height(self, u: Node) -> int:
        # todo
        # my change
        if u is None: return 0
        return 1+max(self._height(u.left),self._height(u.right))
        # end of my change
        #pass

    def height(self) -> int:
        return self._height(self.r)
    
    def _in_order(self, u : Node) -> list:
        # todo
        # my change
        if u is None: return
        else:
            self._in_order(u.left)
            tarvesalList.append(u)
            self._in_order(u.right)
        return tarvesalList
        # end of my change
        #pass

    def in_order(self) -> list:
        tarvesalList.clear()
        return self._in_order(self.r)

    def _pre_order(self, u : Node) -> list:
        # todo
        # my change
        if u is None: return
        else:
            tarvesalList.append(str(u))
            self._pre_order(u.left)
            self._pre_order(u.right)
        return tarvesalList
        # end of my change
        #pass

    def pre_order(self) -> list:
        tarvesalList.clear()
        return self._pre_order(self.r)

    def _post_order(self, u : Node) -> list:
        # todo
        # my change
        if u is None: return
        else:
            self._post_order(u.left)
            self._post_order(u.right)
            tarvesalList.append(str(u))
        return tarvesalList

        # end of my change
        #pass

    def post_order(self) -> list:
        tarvesalList.clear()
        return self._post_order(self.r)

    def bf_traverse(self) -> list:
        # todo
        # my change
        a = []
        q = ArrayQueue.ArrayQueue()
        if(self.r != None): q.add(self.r)
        while(q.size() != 0):
            u = q.remove()
            a.append(u)
            if(u.left != None): q.add(u.left)
            if(u.right != None): q.add(u.right)
        return a
        # end of my change
        #pass 
            
    def first_node(self):
        w = self.r
        if w is None: return None
        while w.left != None:
            w = w.left
        return w
    
    def next_node(self, w):
        if w.right is not None:
            w = w.right
            while w.left is not None:
                w = w.left
        else:
            while w.parent is not None and w.parent.left != w:
                w = w.parent
            w = w.parent
        return w

    def __str__(self):
        nodes = self.bf_traverse()
        nodes_str = [str(node) for node in nodes]
        return ', '.join(nodes_str)