# PROGRAMMING PARADIGMS, TU060 // TU059
## Dr. Pierpaolo Dondio
### Assignment 1 – Prolog Project, Due Date: Sunday 8th December 2024
### 25 marks in total

#### PART 1 (9% of final exam marks)
Your knowledge base (ass1.pro) contains information about flights. For each flight there is a prolog
predicate flight(city-a,city-b,airline,distance,time,cost) meaning that there
is a flight from A to B with a specific Airline, the distance between A and B, the flight time and the flight
cost. For instance:
flight(london,dublin,aerlingus,500,45,150)
flight(rome,london,ba,1500,150,400)
flight(rome,paris,airfrance,1200,120,500)
flight(paris,dublin,airfrance,600,60,200)
The time is expressed in minutes, distance in km, price in euros. You have also information about
the location of each city in the predicate country(city,state). For instance:
country(london,uk)
country(dublin,ireland)
country(rome,italy)
country(paris,france)
country(cork,ireland)
country(shannon,ireland)
….
You are required to write the following PROLOG predicates
#### 1. list_airport(X,L)
where X (input) is a country and L is a list of all airports in that country. Example:
list_airport(ireland,L)
L=[dublin,cork,shannon]
#### 2. trip(X,Y,T)
i.e. a predicate to show the connections from city X to city Y (one by one).
X and Y are the two inputs (city) and T is the output. Each solution T is a list of all the cities
connecting X to Y (X and Y included). Example:
trip(rome,dublin,T)
T=[rome,london,dublin] ; //first solution
T=[rome,paris,dublin] ; //second solution
#### 3. all_trip(X,Y,T)
i.e. a predicate that returns all the connections (trips) from X to Y and place them in T. Therefore T
is a list of lists. Example:
all_trip(rome,Dublin,T).
T=[[rome,london,dublin], [rome,paris,dublin]]
#### 4. trip_dist(X,Y,[T,D])
the predicate returns the distance D for each trip T from city X and Y (one by one). Note that the
output is a list with first element the trip (which is a list) and second element the numeric distance.
Example:
trip_dist(rome,dublin,W)
W=[[rome,london,dublin],2000];
W=[[rome,paris,dublin],1800];
False
#### 5. trip_cost(X,Y,[T,C])
same as trip_dist but C is the total cost of the trip
#### 6. trip_change(X,Y,[T,I])
same as trip_dist but I is the total number of airplanes changed (=0 for direct connections).
Suggestion: use a predicate to compute the length of a list.
#### 7. all_trip_noairline(X,Y,T,A).
same as all_trip, but DISCARD all the trip containing a flight with airline A (for instance the
customer would like to flight from rome to dublin avoiding ryanair)
#### 8. 
cheapest(X,Y,T,C)
shortest(X,Y,T,C)
fastest(X,Y,T,C)
finding the cheapest, shortest, fastest trip T from city X to city Y. C is the cost, distance or time.
Suggestion: use trip_dist (or trip_cost or trip_time) and a predicate to compute the
max or min of a list is needed.
#### 9. trip_to_nation(X,Y,T)
showing all the connections from airport X to country Y (one by one). Example:
trip_to_nation(rome,ireland,T)
T=[rome,london,dublin] ; //first
solution T=[rome,paris,dublin] ;
//second solution T=[rome,paris,cork] ;
//third solution false.
Suggestion: first use list_airport to get all the airports in the country, and then look for the trips
#### 10. all_trip_to_nation(X,Y,T)
Important: to avoid trips with cycles, such as [rome, paris, rome, london, dublin],
keep a list of cities already visited for the trip. A city can be added only if it was not visited so far.