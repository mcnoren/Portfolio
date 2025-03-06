from datastructures.array2d import Array2D
from abc import ABC, abstractmethod

class LifeForm(ABC):

    def __init__(self, alive, symbol):
        self._is_alive = alive
        self._symbol = symbol
    
    @property
    def is_alive(self):
        '''This function returns whether or not the life form is alive'''
        return self._is_alive

    @property
    def symbol(self):
        '''This function returns the symbol of the life form'''
        return self._symbol

    @abstractmethod
    def is_alive_next_generation(self):
        pass

    def count_neighbors(self, array: Array2D, index: tuple) -> int:
        ''' This function takes in the current generation and an index and determines returns the number of neighbors it has.'''
        r, c = index
        rows, columns = array.dimensions
        count = 0
        if c > 0 and array[r][c-1].is_alive:
            count += 1
        if c < columns-1 and array[r][c+1].is_alive:
            count += 1
        if r > 0:
            if array[r-1][c].is_alive:
                count += 1
            if c > 0 and array[r-1][c-1].is_alive:
                count += 1
            if c < columns-1 and array[r-1][c+1].is_alive:
                count += 1
        if r < rows - 1:
            if array[r+1][c].is_alive:
                count += 1
            if c > 0 and array[r+1][c-1].is_alive:
                count += 1
            if c < columns-1 and array[r+1][c+1].is_alive:
                count += 1
        return count
    
    def __eq__(self, other: object) -> bool:
        if not isinstance(other, LifeForm):
            return False
        return self.is_alive == other.is_alive and self.symbol == other.symbol
        

    def __ne__(self, other: object) -> bool:
        return not self == other
    
    def __str__(self):
        return self._symbol