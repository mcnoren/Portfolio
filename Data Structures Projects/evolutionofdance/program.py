from projects.evolutionofdance.dance_line import DanceLine
from projects.evolutionofdance.dancer import Dancer
from random import randint

def main():
    while True:
        rounds = input("# of rounds: ")
        if rounds.isnumeric():
            break
        print("(Must be an integer)")
    rounds = int(rounds)
    dancers = ["🧟", "🧛", "👻", "👽", "🤖", "🤡", "🦖"]
    dance_line = DanceLine(dancers)
    print("Your Dancers are Ready!")
    print(dance_line)
    for i in range(rounds):
        print(f"Round {i + 1}!")
        n = randint(1, 6)
        dance_line.dance(n)
        print(dance_line)
    print("The Dance Off is Over!")

if __name__ == "__main__":
    main()