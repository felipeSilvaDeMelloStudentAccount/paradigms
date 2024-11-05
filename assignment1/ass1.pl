%flight (FromCity, ToCity, Airline, Distance, Duration,Cost)
flight(london,dublin,aerlingus,500,45,150).
flight(rome,london,ba,1500,150,400).
flight(rome,paris,airfrance,1200,120,500).
flight(paris,dublin,airfrance,600,60,200).
flight(berlin,moscow,lufthansa,3000,300,900).
flight(paris,amsterdam,airfrance,400,30,100).
flight(berlin,dublin,lufthansa,1200,120,900).
flight(london,newyork,ba,5000,700,1100).
flight(dublin,newyork,aerlingus,4500,360,800).
flight(dublin,cork,ryanair,300,50,50).
flight(dublin,rome,ryanair,2000,150,70).
flight(dublin,chicago,aerlingus,5500,480,890).
flight(amsterdam,hongkong,klm,7000,660,750).
flight(london,hongkong,ba,7500,700,1000).
flight(dublin,amsterdam,ryanair,1000,90,60).
flight(moscow,newyork,aerflot,9000,720,1000).
flight(moscow,hongkong,aerflot,5500,420,500).
flight(newyork,chicago,aa,3000,240,430).
flight(dublin,london,aerlingus,500,45,150).
flight(london,rome,ba,1500,150,400).
flight(paris,rome,airfrance,1200,120,500).
flight(dublin,paris,airfrance,600,60,200).
flight(moscow,berlin,lufthansa,3000,300,900).
flight(amsterdam,paris,airfrance,400,30,100).
flight(dublin,berlin,lufthansa,1200,120,900).
flight(newyork,london,ba,5000,700,1100).
flight(newyork,dublin,aerlingus,4500,360,800).
flight(cork,dublin,ryanair,300,50,50).
flight(rome,dublin,ryanair,2000,150,70).
flight(chicago,dublin,aerlingus,5500,480,890).
flight(hongkong,amsterdam,klm,7000,660,750).
flight(hongkong,london,ba,7500,700,1000).
flight(amsterdam,dublin,ryanair,1000,90,60).
flight(newyork,moscow,aerflot,9000,720,1000).
flight(hongkong,moscow,aerflot,5500,420,500).
flight(chicago,newyork,aa,3000,240,430).

country(dublin,ireland).
country(cork,ireland).
country(london,uk).
country(rome,italy).
country(moscow,russia).
country(hongkong,china).
country(amsterdam,holland).
country(berlin,germany).
country(paris,france).
country(newyork,usa).
country(chicago,usa).

% Task 1.1
% findall is taking three arguments there Airport, country(Airport, Country), Airports)
% Airport is representing each result of the recursion
% country(Airport, Country) is the query that we want to find all the solutions.
% Airports is the list that will hold all the solutions that match the the query.
list_airport(Country, Airports) :-
    findall(Airport, country(Airport, Country), Airports).

% Get all the outgoing flights
fromConnections(City, Connections) :-
    findall(Connection, flight(City, Connection,_,_,_,_), Connections).
% Get all the incoming flights
toConnections(City, Connections) :-
    findall(Connection, flight(Connection,City,_,_,_,_), Connections).
% Get all outgoing and incoming flights
connections(City, Connections) :-
    fromConnections(City,FromConnections),
    toConnections(City, ToConnections),
    append(FromConnections, ToConnections, Connections).

% Task 1.2
% Direct connection between two cities.
trip(FromCity, ToCity) :-
    flight(FromCity, ToCity, _, _, _, _).

% Build the path between two cities.
trip(FromCity, ToCity, Visited, [FromCity, ConnectionCity, ToCity]) :-
    trip(FromCity, ConnectionCity),
    ConnectionCity \= ToCity, \+ member(ConnectionCity, Visited),
    trip(ConnectionCity, ToCity).

% Main predicate to find paths from city to city.
trip(FromCity, ToCity, Path) :-
    trip(FromCity, ToCity, [FromCity], Path).

% Task 1.3
% Find all routes from city to city.
all_trip(FromCity, ToCity, Routes) :-
    findall(Path, trip(FromCity, ToCity, Path), Routes).


% Task 1.4
% Get the distance from city to city.
direct_distance(FromCity, ToCity, Distance) :-
    flight(FromCity, ToCity, _, Distance, _, _).

% Get the total distance for a path.
trip_dist([_], 0).
trip_dist([FromCity, ToCity | NextCity], Distance) :-
    direct_distance(FromCity, ToCity, D1),
    trip_dist([ToCity | NextCity], DNextCity),
    Distance is D1 + DNextCity.

% Get the distance for each trip from from city to city.
trip_dist(FromCity, ToCity, [Path, Distance]) :-
    trip(FromCity, ToCity, Path),
    trip_dist(Path, Distance).