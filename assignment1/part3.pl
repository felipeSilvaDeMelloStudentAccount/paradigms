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
