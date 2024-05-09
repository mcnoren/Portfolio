from datastructures.array2d import Array2D
from projects.gameoflife.lifeform import LifeForm
from projects.gameoflife.bacteria import Bacteria
import random

class World():

    def __init__(self, grid : Array2D):
        self._grid = grid
    
    def next_generation(self):
        ''' This function takes in the current generation and returns the next generation.'''
        rows, columns = self.grid.dimensions
        next_gen = Array2D(rows, columns)
        for r in range(rows):
            for c in range(columns):
                next_gen[r][c] = Bacteria(self.grid[r][c].is_alive_next_generation(self.grid, (r,c)))
        return World(next_gen)
    
    @property
    def grid(self):
        return self._grid
    
    @staticmethod
    def from_file(filename: str):
        with open(filename) as f:
            row_line = f.readline()
            rows = int(row_line[5:].strip())
            column_line = f.readline()
            columns = int(column_line[8:].strip())
            current_gen = Array2D(rows, columns)
            for r in range(rows):
                row = f.readline().strip()
                while len(row) != columns:
                    row = f.readline().strip()
                for c in range(columns):
                    if row[c] == Bacteria.symbol():
                        current_gen[r][c] = Bacteria(True)
                    else:
                        current_gen[r][c] = Bacteria(False)
        return World(current_gen)
    
    @staticmethod
    def from_randomization(rows: int, columns: int):
        current_gen = Array2D(rows, columns)
        for r in range(rows):
            for c in range(columns):
                if random.randint(0, 1) == 0:
                    current_gen[r][c] = Bacteria(True)
                else:
                    current_gen[r][c] = Bacteria(False)
        return World(current_gen)
    
    def __eq__(self, other: object) -> bool:
        return self.grid == other.grid
    
    def __ne__(self, other: object) -> bool:
        return not self == other
    
    def __str__(self):
        ''' This function prints the generation passed in.'''
        rows, columns = self._grid.dimensions
        row_string = ""
        for r in range(rows):
            for c in range(columns):
                if self.grid[r][c].is_alive:
                    row_string += self._grid[r][c]._symbol
                else:
                    row_string += "-"
                row_string += " "
            row_string += "\n"
        return row_string