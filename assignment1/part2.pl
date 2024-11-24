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

% Main predicate.
high([], _, _).
high([Pile | NextPile], Block, Height) :-
    % Find the block height in the pile.
    (high_in_pile(Pile, Block, 0, Height)
    ; % If not found, Search in the rest of the piles.
    high(NextPile, Block, Height)).
    