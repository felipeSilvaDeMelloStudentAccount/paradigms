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













