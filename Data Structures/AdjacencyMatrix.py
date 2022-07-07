from Interfaces import Graph, List
import ArrayList
import ArrayQueue
import ArrayStack
import numpy as np
"""An implementation of the adjacency list representation of a graph"""

class AdjacencyMatrix(Graph):

    def __init__(self, n : int):
        self.n = n
        self.adj = np.zeros((self.n, self.n), dtype=int)

    def add_edge(self, i : int, j : int):
        # todo
        # my change
        self.adj[i][j] = 1
        # end of my change
        #pass

    def remove_edge(self, i : int, j : int):
        # todo
        # my change
        if self.has_edge(i,j):
            self.adj[i][j] = 0
            return True
        return False
        # end of my change
        #pass

    def has_edge(self, i : int, j: int) ->bool:
        # todo
        # my change
        return self.adj[i][j]
        # end of my change
        #pass

    def out_edges(self, i) -> List:
        # todo
        # my change
        out_edg = ArrayList.ArrayList()
        for j in range(0,len(self.adj[i])):
            if self.has_edge(i,j):
                out_edg.append(j)
        return out_edg
        # end of my change
        #pass

    def in_edges(self, j) -> List:
        # todo
        # my change
        in_edg = ArrayList.ArrayList()
        for i in range(0, self.n):
            if self.has_edge(i,j):
                in_edg.append(i)
        return in_edg
        # end of my change
        #pass

    def bfs(self, r : int):
        # todo
        # my change
        traversal = ArrayList.ArrayList()
        seen = np.zeros((self.n), dtype=int)
        q = ArrayQueue.ArrayQueue()
        traversal.append(r)
        seen[r] = 1
        q.add(r)
        while q.size()>0:
            current = q.remove()
            neighbors = self.out_edges(current)
            for i in range(0, len(neighbors)):
                neighbor = neighbors[i]
                if not seen[neighbor]:
                    q.add(neighbor)
                    traversal.append(neighbor)
                    seen[neighbor] = 1
        return traversal
        # end of my change
        #pass

    def dfs(self, r : int):
        # todo
        # my change
        traversal = ArrayList.ArrayList()
        seen=np.zeros((self.n),dtype=int)
        s = ArrayStack.ArrayStack()
        s.push(r)
        while s.size()>0:
            current = s.pop()
            if not seen[current]:
                traversal.append(current)
                seen[current] = 1
            neighbors = self.out_edges(current)
            for i in range(len(neighbors)-1,-1,-1):
                neighbor = neighbors[i]
                if not seen[neighbor]:
                    s.push(neighbor)                        
        return traversal
        # end of my change
        #pass

    def __str__(self):
        s = ""
        for i in range(0, self.n):
            s += "%i:  %r\n" % (i, self.adj[i].__str__())
        return s


g = AdjacencyMatrix(7)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 3)
g.add_edge(3, 4)
g.add_edge(3, 5)
g.add_edge(3, 6)
g.add_edge(4, 6)
g.add_edge(5, 6)
g.add_edge(6, 5)
# g.add_edge(3, 4)
# g.add_edge(4, 3)
# g.add_edge(4, 5)
# g.add_edge(5, 2)
# g.add_edge(5, 4)

print(g)
print(g.bfs(5))
print(g.dfs(5))

# g = AdjacencyMatrix(12)
# g.add_edge(0, 1)
# g.add_edge(0, 9)
# g.add_edge(1, 0)
# g.add_edge(1, 2)
# g.add_edge(1, 10)
# g.add_edge(1, 11)
# g.add_edge(2, 1)
# g.add_edge(2, 3)
# g.add_edge(2, 11)
# g.add_edge(3, 2)
# g.add_edge(3, 4)
# g.add_edge(4, 3)
# g.add_edge(4, 5)
# g.add_edge(4, 11)
# g.add_edge(5, 4)
# g.add_edge(5, 6)
# g.add_edge(6, 5)
# g.add_edge(6, 7)
# g.add_edge(6, 11)
# g.add_edge(7, 6)
# g.add_edge(7, 8)
# g.add_edge(7, 10)
# g.add_edge(8, 7)
# g.add_edge(8, 9)
# g.add_edge(9, 0)
# g.add_edge(9, 8)
# g.add_edge(9, 10)
# g.add_edge(10, 1)
# g.add_edge(10, 7)
# g.add_edge(10, 9)
# g.add_edge(10, 11)
# g.add_edge(11, 2)
# g.add_edge(11, 4)
# g.add_edge(11, 6)
# g.add_edge(11, 10)

# print(g)
# print("BFS(0):", g.bfs(0))
# print("Expected: [0, 1, 9, 2, 10, 11, 8, 3, 7, 4, 6, 5]")
# print("\nDFS(0):", g.dfs(0))
# print("Expected: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]")


