import csv
from typing import Any, NamedTuple
from datastructures.graph import Graph
from datastructures.array import Array
from datastructures.list_stack import ListStack
from haversine import haversine, Unit
import numpy as np

class Airport(NamedTuple):
    id: int
    name: str
    code: str
    city: str
    country: str
    latitude: float
    longitude: float

class Flight():
    def __init__(self, origin: Airport, destination: Airport) -> None:
        self._origin: Airport = origin
        self._destination: Airport = destination

    @property
    def weight(self) -> float:
        origin = (self._origin.latitude, self._origin.longitude)
        destination = (self._destination.latitude, self._destination.longitude)
        return haversine(origin, destination, Unit.MILES)
    
    def __lt__(self, object: Any) -> bool:
        if not isinstance(object, Flight):
            return False
        
        return self.weight < object.weight


def read_csv(filename: str) -> Graph:
    graph = Graph()

    csv_reader = csv.DictReader(open(filename, newline="\n", encoding="utf-8-sig"))

    for row in csv_reader:
        origin = Airport(
            int(row['origin_airport_id']), 
            row['origin_airport'], 
            row['origin_airport_code'], 
            row['origin_city'], 
            row['origin_country'], 
            float(row['origin_airport_latitude']), 
            float(row['origin_airport_longitude']))
        
        destination = Airport(
            int(row['destination_airport_id']), 
            row['destination_airport'], 
            row['destination_airport_code'], 
            row['destination_city'], 
            row['destination_country'], 
            float(row['destination_airport_latitude']), 
            float(row['destination_airport_longitude']))

        flight = Flight(origin, destination)
        weight = flight.weight
        graph.add_edge(origin, destination, flight, weight)

    return graph

# def compare_edges() -> None:
#     graph = Graph()
    
#     seattle = Airport()
#     portland = Airport()
#     olympia = Airport()

#     flight1 = Flight(seattle, portland)
#     flight2 = Flight(seattle, olympia)
#     flight3 = Flight(olympia, portland)

#     graph.add_edge(seattle, portland, flight1, flight1.weight)
#     graph.add_edge(seattle, olympia, flight2, flight2.weight)
#     graph.add_edge(olympia, portland, flight3, flight3.weight)


#     seattle_outbound = graph.edges_from(seattle)

#     seattle_outbound = sorted(seattle_outbound)


def demo_sort():

    airport1 = Airport(1, "Portland", "PDX", "Portland, OR", "USA", 45.58869934,-122.5979996)
    airport2 = Airport(2, "Seattle", "SEA", "Seattle, WA", "USA", 47.44900131,-122.3089981)
    airport3 = Airport(3, "San Francisco", "SFO", "San Francisco, CA", "USA", 37.61899948,-122.375)

    flight1 = Flight(airport1, airport2)
    flight2 = Flight(airport1, airport3)
    flight3 = Flight(airport3, airport2)
    flight4 = Flight(airport2, airport3)
    flight5 = Flight(airport2, airport1)
    flight6 = Flight(airport3, airport1)

    distance = [flight1.weight, 
                flight2.weight, 
                flight3.weight, 
                flight4.weight, 
                flight5.weight, 
                flight6.weight]
    
    print(sorted(distance, key=lambda x: x))

    flights = [flight1, flight2, flight3, flight4, flight5, flight6]

    sorted_flights = sorted(flights, key=lambda flight: flight.weight)

def main():
    graph: Graph = read_csv("./projects/dijkstrasshortestpath/routes.csv")
    running = True
    while running:
        origin: str = ""
        origin_airport = None
        while origin_airport is None:
            origin = input("Enter the origin airport code or Q to quit: ")
            origin = origin.upper()
            if origin == "Q":
                running = False
                break
            for airport in graph.vertices:
                if airport.code == origin:
                    origin_airport = airport
                    break
            if origin_airport is None:
                print("Invalid airport code. Please try again.")
        if not running:
            break
        destination_airport = None
        while destination_airport is None:
            destination = input("Enter the destination airport code: ")
            destination = destination.upper()
            for airport in graph.vertices:
                if airport.code == destination:
                    destination_airport = airport
                    break
            if destination_airport is None:
                print("Invalid airport code. Please try again.")
        
        distances_from_origin = {}
        for airport in graph.vertices:
            if airport == origin_airport:
                distances_from_origin[airport.code] = 0
            else:
                distances_from_origin[airport.code] = np.inf
        
        previous_chain = {}
        for airport in graph.vertices:
            previous_chain[airport.code] = None
        
        visited = Array()

        unvisited = graph.vertices

        while len(unvisited) > 0:
            current_airport = min(unvisited, key=lambda airport: distances_from_origin[airport.code])
            unvisited.remove(current_airport)
            visited.append(current_airport)

            for flight in graph.edges_from(current_airport):
                potential_distance = flight.weight + distances_from_origin[current_airport.code]
                if potential_distance < distances_from_origin[flight._destination.code]:
                    distances_from_origin[flight._destination.code] = potential_distance
                    previous_chain[flight._destination.code] = current_airport.code
        
        path = ListStack()
        airport = destination_airport.code
        while airport is not None:
            path.push(airport)
            airport = previous_chain[airport]
        
        while not path.empty:
            airport = path.pop()
            print(f"{airport} - {distances_from_origin[airport]} miles")


        


        


if __name__ == "__main__":
    main()