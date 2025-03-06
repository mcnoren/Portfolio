from datastructures.array2d import Array2D
from projects.gameoflife.kbhit import KBHit
from projects.gameoflife.world import World
import random
import copy
import time


def main():
    # user input
    while True:
        answer = input("Would you like to import world from 'world.txt'? (y/n): ")
        if answer == 'y' or answer == 'n':
            break
        print("invalid input")
    if answer == 'y':
        use_file = True
    else:
        use_file = False
    while True:
        answer = input("Would you like to manualy cycle through generations? (y/n): ")
        if answer == 'y' or answer == 'n':
            break
        print("invalid input")
    if answer == 'y':
        cycle_manually = True
    else:
        cycle_manually = False

    # gets generation from world.txt
    if use_file:
        current_gen = World.from_file("./projects/gameoflife/world.txt")
    # gets generaton from randomization
    else:
        rows = 10
        columns = 10
        current_gen = World.from_randomization(rows, columns)
    

    generation = 0

    kb = KBHit()
    sleeptime = 1

    if cycle_manually:
        print("Hit space bar to go to next generation, or ESC to exit")
    else:
        print("Hit ESC to exit")
    print()
    print(f'Generation: {generation}')
    print(current_gen)
    time.sleep(sleeptime)

    # main loop for generations
    while True:
        if not cycle_manually:
            generation += 1
            print(f'Generation: {generation}')
            next_gen = current_gen.next_generation()
            print(next_gen)
            if current_gen == next_gen:
                print("Stable")
                break
            current_gen = copy.deepcopy(next_gen)
            time.sleep(sleeptime)
        if kb.kbhit():
            c = (kb.getch())
            c_ord = ord(c)
            if c_ord == 27: # ESC
                break
            if cycle_manually:
                if c_ord == 32:
                    generation += 1
                    print(f'Generation: {generation}')
                    next_gen = current_gen.next_generation()
                    print(next_gen)
                    if current_gen == next_gen:
                        print("Stable")
                        break
                    current_gen = copy.deepcopy(next_gen)

if __name__ == "__main__":
    main()
