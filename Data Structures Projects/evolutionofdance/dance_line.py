from datastructures.linked_list import LinkedList
from datastructures.list_node import ListNode
from projects.evolutionofdance.dancer import Dancer
import random

class DanceLine:

    def __init__(self, types):
        self._types = types
        self._list = LinkedList()
        for t in self._types:
            self._list.append(Dancer(t))

    def dance(self, num: int):
        dancer = self.get_dancer()
        match num:
            case 1:
                self.calypso(dancer)
                print(f"{dancer} joins and starts the \"Calypso!\"")
            case 2:
                self.electric_slide(dancer)
                print(f"{dancer} joins and starts the \"Electric Slide!\"")
            case 3:
                self.macarena(dancer)
                print(f"{dancer} joins and starts the \"Macarena!\"")
            case 4:
                self.mash_potato(dancer)
                print(f"{dancer} joins and starts the \"Mash Potato!\"")
            case 5:
                self.hustle(dancer)
                print(f"{dancer} joins and starts the \"Hustle!\"")
            case 6:
                self.tootsie_roll(dancer)
                print(f"{dancer} joins and starts the \"Tootie Roll!\"")

    def get_dancer(self):
        i = random.randrange(0, len(self._types))
        return Dancer(self._types[i])

    def calypso(self, dancer):
        self._list.prepend(dancer)
    
    def electric_slide(self, dancer):
        self._list.append(dancer)
    
    def macarena(self, dancer):
        pos = random.randint(0, len(self._list))
        if pos == 0:
            self._list.prepend(dancer)
        elif pos == len(self._list):
            self._list.append(dancer)
        else:
            travel = self._list.head
            for i in range(pos):
                travel = travel.next
            travel.previous.next = ListNode(dancer)
            travel.previous.next.previous = travel.previous
            travel.previous = travel.previous.next
            travel.previous.next = travel
        
    def mash_potato(self, dancer):
        self._list.extract(dancer)
        self._list.append(dancer)

    def hustle(self, dancer):
        self._list.prepend(dancer)
        self._list.append(dancer)
        mid = len(self._list) // 2
        travel = self._list.head
        for i in range(mid):
            travel = travel.next
        travel.previous.next = ListNode(dancer)
        travel.previous.next.previous = travel.previous
        travel.previous = travel.previous.next
        travel.previous.next = travel

    def tootsie_roll(self, dancer):
        self._list.prepend(dancer)
        for t in self._types:
            self._list.append(Dancer(t))
    
    def __str__(self):
        return str(self._list)