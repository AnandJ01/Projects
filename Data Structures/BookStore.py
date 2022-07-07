import Book
import algorithms
import ArrayList
import ArrayQueue
import RandomQueue
import MaxQueue
import DLList
import SLLQueue
import ChainedHashTable
import BinarySearchTree 
import BinaryHeap 
import AdjacencyList 
import time

class BookStore:
    '''
    BookStore: It simulates a book system such as Amazon. It allows  searching,
    removing and adding in a shopping cart. 
    '''
    def __init__(self) :
        # change bookcatalog back to none if arraylist dosent work
        self.bookCatalog = None
        self.bookIndices = ChainedHashTable.ChainedHashTable()
        self.shoppingCart = MaxQueue.MaxQueue()
        self.sortedTitleIndices = BinarySearchTree.BinarySearchTree()
        

    def loadCatalog(self, fileName : str) :
        '''
            loadCatalog: Read the file filenName and creates the array list with all books.
                book records are separated by  ^. The order is key, 
                title, group, rank (number of copies sold) and similar books
        '''
        self.bookCatalog = ArrayList.ArrayList()
        with open(fileName, encoding="utf8") as f:
            # The following line is the time that the computation starts
            start_time = time.time()
            for line in f:
                (key, title, group, rank, similar) = line.split("^")
                s = Book.Book(key, title, group, rank, similar)
                self.bookCatalog.append(s)
                self.bookIndices.add(key, self.bookCatalog.size()-1)
                self.sortedTitleIndices.add(title, self.bookCatalog.size()-1)

            # The following line is used to calculate the total time 
            # of execution
            elapsed_time = time.time() - start_time
            print(f"Loading {self.bookCatalog.size()} books in {elapsed_time} seconds")

        
    def setRandomShoppingCart(self) :
        q = self.shoppingCart
        start_time = time.time()
        self.shoppingCart = MaxQueue.MaxQueue()
        #self.shoppingCart = RandomQueue.RandomQueue()
        while q.size() > 0:
            self.shoppingCart.add(q.remove())
        elapsed_time = time.time() - start_time
        print(f"Setting radomShoppingCart in {elapsed_time} seconds")
    
    def setShoppingCart(self) :
        q = self.shoppingCart
        start_time = time.time()
        self.shoppingCart = DLList.DLList()
        #self.shoppingCart = ArrayQueue.ArrayQueue()
        while q.size() > 0:
            self.shoppingCart.add(q.remove())
        elapsed_time = time.time() - start_time
        print(f"Setting radomShoppingCart in {elapsed_time} seconds")


    def removeFromCatalog(self, i : int) :
        '''
        removeFromCatalog: Remove from the bookCatalog the book with the index i
        input: 
            i: positive integer    
        '''
        # The following line is the time that the computation starts
        start_time = time.time()
        self.bookCatalog.remove(i)
        # The following line is used to calculate the total time 
        # of execution
        elapsed_time = time.time() - start_time
        print(f"Remove book {i} from books in {elapsed_time} seconds")

    def addBookByIndex(self, i : int) :
        '''
        addBookByIndex: Inserts into the playlist the song of the list at index i 
        input: 
            i: positive integer    
        '''
        # Validating the index. Otherwise it  crashes
        if i >= 0 and i < self.bookCatalog.size():
            start_time = time.time()
            s = self.bookCatalog.get(i)
            self.shoppingCart.add(s)
            elapsed_time = time.time() - start_time
            print(f"Added to shopping cart {s} \n{elapsed_time} seconds")

   
    def searchBookByInfix(self, infix : str) :
        '''
        searchBookByInfix: Search all the books that contains infix
        input: 
            infix: A string    
        '''
        start_time = time.time()
        # todo
        # my change
        counter = 0
        if(infix == ""):
            for j in range(0,50):
                try:
                    #print(self.bookCatalog[j])
                    print(self.bookCatalog.get(j))
                except IndexError:
                    break
        else :
            for book in self.bookCatalog:
                if infix in book.title:
                    if counter == 50:
                        break
                    else:
                        print(book)
                        counter+=1

        # end of my change
        elapsed_time = time.time() - start_time
        print(f"searchBookByInfix Completed in {elapsed_time} seconds")

    def removeFromShoppingCart(self) :
        '''
        removeFromShoppingCart: remove one book from the shoppung cart  
        '''
        start_time = time.time()
        if self.shoppingCart.size() > 0:
            u = self.shoppingCart.remove()
            elapsed_time = time.time() - start_time
            print(f"removeFromShoppingCart {u} Completed in {elapsed_time} seconds")

    # my change
    def getCartBestSeller(self):
        start_time = time.time()
        book = self.shoppingCart.max()
        elapsed_time = time.time() - start_time
        print(book.title)
        print(f"getCartBestSeller Completed in {elapsed_time} seconds")
    # end of my change

    # my change
    def addBookByKey(self, key: int):
        start_time = time.time()
        i = self.bookIndices.find(key)
        if i != None:
            s = self.bookCatalog.get(i)
            self.shoppingCart.add(s)
            elapsed_time = time.time()-start_time
            print(f"Added title: {s.title} \naddBookByKey Completed in {elapsed_time} seconds")
        else:
            elapsed_time = time.time()-start_time
            print(f"Book not found\naddBookByKey Completed in {elapsed_time} seconds")
    # end of my change

    # my change
    def addBookByPrefix(self, prefix):
        start_time = time.time()
        if prefix != "":
            index = self.sortedTitleIndices.find(prefix).v
            if index is not None:
                s = self.bookCatalog.get(index)
                self.shoppingCart.add(s)
                elapsed_time = time.time()-start_time
                print(f"Added title: {s.title} \naddBookByPrefix Completed in {elapsed_time} seconds")
                return True
        elapsed_time = time.time()-start_time
        print(f"Book not found\naddBookByPrefix Completed in {elapsed_time} seconds")
        return False
    # end of my change

    # my change
    def bestsellers_with(self,infix:str, structure:int, n=0):
        if infix == "": print("Invalid infix.")
        elif n <0: print("Invalid number of titles")
        else:
            if structure <= 0 and structure >= 3:
                print("Invalid data structure.")
            else:
                start_time = time.time()
                if structure == 1:
                    bst = BinarySearchTree.BinarySearchTree()
                    counter = 0
                    for book in self.bookCatalog:
                        if infix in book.title:
                            bst.add(book.rank, book)
                    bst_rank = bst.in_order()
                    bst_rank.reverse()
                    for node in bst_rank:
                        print(node.v)
                        if n!=0:
                            counter+=1
                            if counter==n:
                                break
                else:
                    bh = BinaryHeap.BinaryHeap()
                    counter = 0
                    for book in self.bookCatalog:
                        if infix in book.title:
                            book.rank = -1*book.rank
                            bh.add(book)
                    for i in range(0,bh.size(),1):
                        b = bh.remove()
                        b.rank = -1*b.rank
                        print(b)
                        if n!=0:
                            counter+=1
                            if counter==n:
                                break
                elapsed_time = time.time() - start_time
                print(f"Displayed bestseller_with({infix}, {structure},{n}) in {elapsed_time} seconds")
    # end of my change

    # my change
    def sort_catalog(self, s: int):
        if s==1:
            start_time = time.time()
            algorithms.merge_sort(self.bookCatalog)
            elapsed_time = time.time()-start_time
            print(f"Sorted {self.bookCatalog.size()} books in {elapsed_time} seconds")
        elif s==2:
            start_time = time.time()
            algorithms.quick_sort(self.bookCatalog,False)
            elapsed_time = time.time()-start_time
            print(f"Sorted {self.bookCatalog.size()} books in {elapsed_time} seconds")
        elif s==3:
            start_time = time.time()
            algorithms.quick_sort(self.bookCatalog,True)
            elapsed_time = time.time()-start_time
            print(f"Sorted {self.bookCatalog.size()} books in {elapsed_time} seconds")
    # end of my change

    # my change
    def search_by_prefix(self, prefix, algo):
        bookcatalogcopy = ArrayList.ArrayList()
        for x in self.bookCatalog:
            bookcatalogcopy.append(x)
        foundbooks = 0
        start_time = time.time()
        if(algo == 1):
            i=0
            while i< 1:
                index = None
                b = Book.Book("1",prefix,"1","1","1")
                index = algorithms.linear_search(bookcatalogcopy,b)
                if(index >=0):
                    foundbooks+=1
                    print(bookcatalogcopy.remove(index))
                    i-=1
                i+=1
        elif(algo==2):
            algorithms.merge_sort(bookcatalogcopy)
            i = 0
            while i<1:
                index = None
                b = Book.Book("1",prefix,"1","1","1")
                index = algorithms.binary_search(bookcatalogcopy, b)
                if(index >=0):
                    foundbooks+=1
                    print(bookcatalogcopy.remove(index))
                    i-=1
                i+=1
        elapsed_time = time.time()-start_time
        print(f"Found {foundbooks} books with prefix {prefix} in {elapsed_time} seconds.")
    # end of my change

    # my change
    def display_catalog(self, n):
        for i in range(0,n):
            print(self.bookCatalog.get(i))
    # end of my change
    
    # def search by prefix
    # determine which algorithm was chosen
    # if binary search make sure catalog is sorted first
    # if linear search dosen't need a sorted catalog
    # search for the prefix 
    # determin if it was found or not
    # if not remove form catalog so it will not be found again
    # repreat until found or until max searches

    # def display catalog:
    # make sure to print no more than n books
    # make sure n is no longer than the catalog

