% Assignment 1 - Prolog Project - 25 Marks
% Module: PROG9810:2024-25
% Student Name: Felipe Silva de Mello
% Student ID: D23125661
% Email : D23125661@mytudublin.ie



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

% Task 1
% findall is taking three arguments there Airport, country(Airport, Country), Airports)
% Airport is representing each result of the recursion
% country(Airport, Country) is the query that we want to find all the solutions.
% Airports is the list that will hold all the solutions that match the the query.
list_airport(Country, Airports) :-
    findall(Airport, country(Airport, Country), Airports).

% All the outgoing flights
fromConnections(City, Connections) :-
    findall(Connection, flight(City, Connection,_,_,_,_),
    Connections).
% All the incoming flights
toConnections(City, Connections) :-
    findall(Connection, flight(Connection,City,_,_,_,_),
    Connections).
% All outgoing and incoming flights
connections(City, Connections) :-
    fromConnections(City,FromConnections),
    toConnections(City, ToConnections),
    append(FromConnections, ToConnections, Connections).

% Task 2
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

% Task 3
% Find all routes from city to city.
all_trip(FromCity, ToCity, Routes) :-
    findall(Path, trip(FromCity, ToCity, Path), Routes).


% Task 1.4
% Distance from city to city.
direct_distance(FromCity, ToCity, Distance) :-
    flight(FromCity, ToCity, _, Distance, _, _).

% Total distance for a path.
trip_dist([_], 0).
trip_dist([FromCity, ToCity | NextCity], Distance) :-
    direct_distance(FromCity, ToCity, D1),
    trip_dist([ToCity | NextCity], DNextCity),
    Distance is D1 + DNextCity.

% Distance for each trip from from city to city.
trip_dist(FromCity, ToCity, [Path, Distance]) :-
    trip(FromCity, ToCity, Path),
    trip_dist(Path, Distance).

% Task 5
% Cost of a direct flight.
direct_cost(FromCity, ToCity, Cost) :-
    flight(FromCity, ToCity, _, _, Cost, _).

% Cost of a path.
trip_cost([_], 0).
trip_cost([FromCity, ToCity | NextCity], Cost) :-
    direct_cost(FromCity, ToCity, C1),
    trip_cost([ToCity | NextCity], CNextCity),
    Cost is C1 + CNextCity.

% Total cost for a trip from city to city.
trip_cost(FromCity, ToCity, [Path, Cost]) :-
    trip(FromCity, ToCity, Path),
    trip_cost(Path, Cost).

% Task 6
% Length of a list.
list_length([], 0).
list_length([_|Tail], Length) :-
    list_length(Tail, TailLength),
    Length is TailLength + 1.

% Number of airplanes changes for a trip.
trip_change(FromCity, ToCity, [Path, Changes]) :-
    trip(FromCity, ToCity, Path),
    list_length(Path, PathLength),
    Changes is PathLength - 2.

% Task 7
% All trips from city to city, that does not contain the specified Airline.
path_contains_airline([_], _) :- false.
path_contains_airline([FromCity, ToCity | Rest], Airline) :-
    flight(FromCity, ToCity, Airline, _, _, _), !;  % Check if the flight is found.
    path_contains_airline([ToCity | Rest], Airline).  % continue checking.

% Main - Get all trips from city to City, removing the specified Airline.
all_trip_noairline(FromCity, ToCity, Airline, Result) :-
    findall(
        Path,
        (
            trip(FromCity, ToCity, Path),
            \+
            path_contains_airline(Path, Airline)
        ),
        Result
    ).

% Task 8
% Trip Duration
% Duration of a direct flight.
direct_time(FromCity, ToCity, Duration) :-
    flight(FromCity, ToCity, _, _, Duration, _).

% Calculate the total duration for a path.
trip_time([_], 0).
trip_time([FromCity, ToCity | NextCity], TotalTime) :-
    direct_time(FromCity, ToCity, T1),
    trip_time([ToCity | NextCity], TNext),
    TotalTime is T1 + TNext.

% Total duration for a trip from city to city.
trip_time(FromCity, ToCity, [Path, TotalTime]) :-
    trip(FromCity, ToCity, Path),
    trip_time(Path, TotalTime).

% Minimum value in a list
min_trip([TripValue], TripValue).
min_trip([[Trip1, Value1], [Trip2, Value2] | Rest], MinTrip) :-
    (Value1 =< Value2 -> min_trip([[Trip1, Value1] | Rest], MinTrip)
    ;
    min_trip([[Trip2, Value2] | Rest], MinTrip)).

% Cheapest trip from city to city.
cheapest(FromCity, ToCity, Trip, Cost) :-
    findall([Path, TripCost],
    trip_cost(FromCity, ToCity, [Path, TripCost]), Trips),
    min_trip(Trips, [Trip, Cost]).

% Shortest trip from city to city.
shortest(FromCity, ToCity, Trip, Distance) :-
    findall([Path, TripDistance],
    trip_dist(FromCity, ToCity, [Path, TripDistance]), Trips),
    min_trip(Trips, [Trip, Distance]).


% Fastest trip from city to city.
fastest(FromCity, ToCity, Trip, Duration) :-
    findall([Path, TripDuration],
    trip_time(FromCity, ToCity, [Path, TripDuration]), Trips),
    min_trip(Trips, [Trip, Duration]).

% Task 9
% trip_to_nation(dublin, italy, T).
% All connections from airport to country.
trip_to_nation(FromCity, Country, Trip) :-
    list_airport(Country, Airports),
    member(ToCity, Airports),
    trip(FromCity, ToCity, Trip).


% Task 10
% Visited: List of cities already visited.
find_trip_no_cycles(FromCity, ToCity, Visited, [FromCity, ToCity]) :-
     flight(FromCity, ToCity, _, _, _, _),
     \+ member(ToCity, Visited).

find_trip_no_cycles(FromCity, ToCity, Visited, [FromCity | RestOfTrip]) :-
    flight(FromCity, NextCity, _, _, _, _),
    NextCity \= ToCity,
    \+ member(NextCity, Visited),
    find_trip_no_cycles(NextCity, ToCity, [NextCity | Visited], RestOfTrip).

all_trip_to_nation(FromCity, Country, Trip) :-
    list_airport(Country, Airports),
    member(ToCity, Airports),
    find_trip_no_cycles(FromCity, ToCity, [FromCity], Trip).


% ************************ PART 2 ************************ PART 2 ************************   %
% Print a row
print_row([]).
print_row([Element]):- write('|'), write(Element), write('|').
print_row([Element | NextElement]):- write('|'), write(Element), print_row(NextElement).

% Print the blocks
print_status([]).
print_status([Row | NextRow]):- print_row(Row), nl, print_status(NextRow).



% Find the block height in a pile.
high_in_pile([Block | _], Block, AccumulateHeight, AccumulateHeight).
high_in_pile([_ | NextBlock], Block, AccumulateHeight, Height) :-
    CurrentHeight is AccumulateHeight + 1,
    high_in_pile(NextBlock, Block, CurrentHeight, Height).

% Find Hight.
high([], _, _).
high([Pile | NextPile], Block, Height) :-
    % Find the high block in the pile.
    (high_in_pile(Pile, Block, 0, Height)
    ; % Search in the rest of the piles.
    high(NextPile, Block, Height)).

block_at_height(Pile, Height, Block) :-
    block_at_height(Pile, Height, 0, Block).

block_at_height([Block | _], TargetHeight, CurrentHeight, Block) :-
    TargetHeight =:= CurrentHeight.

block_at_height([_ | RestBlocks], TargetHeight, CurrentHeight, Block) :-
    NextHeight is CurrentHeight + 1,
    block_at_height(RestBlocks, TargetHeight, NextHeight, Block).

block_at_height([], _, _, _) :- fail.

% All blocks at the same height.
all_same_height([], _, []).
all_same_height([Pile | NextPile], Height, Blocks) :-
    (
        block_at_height(Pile, Height, Block)
        ->  Blocks = [Block | RestBlocks]
        ;   Blocks = RestBlocks
    ),
    all_same_height(NextPile, Height, RestBlocks).


% Move block
% Update a stack at a specific index in the list of stacks
update_stack_at_index([_|T], 1, NewElement, [NewElement|T]).
update_stack_at_index([H|T], N, NewElement, [H|R]) :-
    N > 1,
    N1 is N - 1,
    update_stack_at_index(T, N1, NewElement, R).

% Print stacks in column format
print_stacks(Stacks) :-
    maplist(print_stack, Stacks).

% Print a single stack with elements separated by bars
print_stack([]) :-
    write('| |\n'). % Empty stack representation
print_stack(Stack) :-
    write('|'),
    maplist(write_element, Stack),
    write('\n').

% Print a single stack element with a bar
write_element(Element) :-
    write(Element),
    write('|').

% Print "before" and "after" stacks
print_before_after(StacksBefore, StacksAfter) :-
    write('Before:\n'),
    print_stacks(StacksBefore),
    write('After:\n'),
    print_stacks(StacksAfter).

% Check if an element is on top of a source stack
check_element_on_top(SourceStack, Element, RestSource) :-
    (append(RestSource, [Element], SourceStack) ->
        true
    ;
        write('Error: Element is not on top of the source stack!\n'), fail
    ).

% Helper to retrieve the stack at a given index (1-based)
get_stack_at_index(Index, Stacks, Stack) :-
    nth1(Index, Stacks, Stack).

% Move an element from one stack to another.
moveblock(StacksBefore, StacksAfter, Element, SourceIndex, DestIndex) :-
    % Get source and destination stacks
    get_stack_at_index(SourceIndex, StacksBefore, SourceStack),
    get_stack_at_index(DestIndex, StacksBefore, DestStack),

    check_element_on_top(SourceStack, Element, RestSource),

    append(DestStack, [Element], NewDestStack),

    % Rebuild the stacks with updated Source and Destination
    update_stack_at_index(StacksBefore, SourceIndex, RestSource, TempStacks),
    update_stack_at_index(TempStacks, DestIndex, NewDestStack, StacksAfter),

    % Print before and after the move
    print_before_after(StacksBefore, StacksAfter).

moveblock(StacksBefore, Element, SourceIndex, DestIndex) :-
    moveblock(StacksBefore, _, Element, SourceIndex, DestIndex).

% ************************ PART 3 ************************ PART 3 ************************   %
generate_moves(0, []).
generate_moves(MoveCount, [move|RemainingMoves]) :-
    MoveCount > 0,
    RemainingMovesCount is MoveCount - 1,
    generate_moves(RemainingMovesCount, RemainingMoves).

split_sorted_elements(SortedElements, Count, Front, Back) :-
    length(Front, Count),
    append(Front, Back, SortedElements).

redistribute_elements([], [], [], []).
redistribute_elements(SortedElements, [OriginalStack|RemainingOriginalStacks],
                      [RedistributedStack|RemainingRedistributedStacks], Moves) :-
    length(OriginalStack, StackSize),
    split_sorted_elements(SortedElements, StackSize, RedistributedStack, RemainingElements),
    redistribute_elements(RemainingElements, RemainingOriginalStacks,
                          RemainingRedistributedStacks, RemainingMoves),
    generate_moves(StackSize, CurrentMoves),
    append(CurrentMoves, RemainingMoves, Moves).
% Order Blocks
order_blocks(Stacks, SortedStacks, NumberOfMoves) :-
    flatten(Stacks, CombinedElements),
    sort(CombinedElements, SortedElements),
    redistribute_elements(SortedElements, Stacks, SortedStacks, Moves),
    length(Moves, NumberOfMoves).