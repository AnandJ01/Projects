from BinaryTree import BinaryTree
from Interfaces import Set


class BinarySearchTree(BinaryTree, Set):

    def __init__(self):
        BinaryTree.__init__(self)
        self.n = 0
        
    def clear(self):
        self.r = None
        self.n = 0

    def new_node(self, x):
        u = BinaryTree.Node(x)
        u.left = u.right = u.parent = None
        return u

    def find_eq(self, x : object) -> object:
        # todo
        # my change
        temp = self.r
        while temp!=None:
            if x<temp.x: temp = temp.left
            elif x>temp.x: temp = temp.right
            else: return temp
        return None
        # end of my change
        #pass
        
    def find_last(self, x : object) -> BinaryTree.Node:
        # todo
        # my change
        w = self.r
        prev = None
        while w != None:
            prev = w
            if x<w.x: w = w.left
            elif x>w.x: w = w.right
            else: return w
        return prev
        # end of my change
        #pass

    def find(self, x: object) -> object:
        # todo
        # my change
        w = self.r
        z = None
        while w != None:
            if x<w.x:
                z = w
                w = w.left
            elif x>w.x: w = w.right
            else: return w
        return z
        # end of my change
        #pass
        
    def add_child(self, p : BinaryTree.Node, u : BinaryTree.Node) -> bool:
        # todo
        # my change
        u.parent = p
        if p is None: self.r = u
        else:
            if u.x<p.x: p.left = u
            elif u.x>p.x: p.right = u
            else: return False
        self.n += 1
        return True
        # end of my change
        #pass
        
    def add_node(self, u : BinaryTree.Node) -> bool:
        p = self.find_last(u.x)
        return self.add_child(p, u)

    def add(self, key : object, value : object) -> bool:
        # todo
        # my change
        if self.r is None:
            self.r = self.new_node(key)
            self.r.set_val(value)
            self.n += 1
            return True
        else:
            p = self.find_last(key)
            added = self.add_child(p, self.new_node(key))
            if key<p.x: p.left.set_val(value)
            elif key>p.x: p.right.set_val(value)
            return added
        # end of my change
        #pass

    def get(self, key : object) -> object:
        # todo
        # my change
        n = self.find_eq(key)
        if n is None: return None
        return n.v
        # end of my change
        #pass
    
    def splice(self, u: BinaryTree.Node):
        # todo
        # my change
        if u.left is not None: s = u.left
        else: s = u.right
        p = None
        if self.r == u: self.r = s
        else:
            p = u.parent
            if u == p.left: p.left = s
            else: p.right = s
        if s is not None: s.parent = p
        self.n -= 1
        # end of my change
        #pass 

    def remove_node(self, u : BinaryTree.Node):
        # todo
        # my change
        if u is not None:
            temp = u.v
            if u.right is None or u.left is None: self.splice(u)
            else:
                w = u.right
                while w.left is not None:
                    w=w.left
                u.x = w.x
                u.v = w.v
                self.splice(w)
            return temp
        return None

        # end of my change
        #pass 

    def remove(self, x : object) -> bool:
        # todo
        # my change
        w = self.find_eq(x)
        if w is None: raise ValueError
        return self.remove_node(w)
        # end of my change
        #pass 
             
    def __iter__(self):
        u = self.first_node()
        while u is not None:
            yield u.x
            u = self.next_node(u)
