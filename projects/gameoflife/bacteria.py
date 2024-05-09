from datastructures.array2d import Array2D
from projects.gameoflife.lifeform import LifeForm

class Bacteria(LifeForm):

    def __init__(self, is_alive):
        symbol = "x"
        super().__init__(is_alive, symbol)
    
    @staticmethod
    def symbol():
        return "x"

    def is_alive_next_generation(self, grid: Array2D, index: tuple):
        ''' This function takes in the current generation and an index and determines whether the index in the next generation will be alive.'''
        r, c = index
        neighbors = self.count_neighbors(grid, index)
        if neighbors == 2:
            return self.is_alive
        if neighbors == 3:
            return True
        else:
            return False