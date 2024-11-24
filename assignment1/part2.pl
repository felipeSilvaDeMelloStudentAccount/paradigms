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

% Get block at a specified height.
block_at_height(Pile, Height, Block) :-
    block_at_height(Pile, Height, 0, Block).

block_at_height([Block | _], TargetHeight, CurrentHeight, Block) :-
    TargetHeight =:= CurrentHeight.

block_at_height([_ | RestBlocks], TargetHeight, CurrentHeight, Block) :-
    NextHeight is CurrentHeight + 1,
    block_at_height(RestBlocks, TargetHeight, NextHeight, Block).

block_at_height([], _, _, _) :- fail.

% Get all blocks at the same height.
all_same_height([], _, []).
all_same_height([Pile | NextPile], Height, Blocks) :-
    (
        block_at_height(Pile, Height, Block)
        ->  Blocks = [Block | RestBlocks]
        ;   Blocks = RestBlocks
    ),
    all_same_height(NextPile, Height, RestBlocks).