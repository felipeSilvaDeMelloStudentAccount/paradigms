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

    % Ensure the element is on top of the source stack (last element in list)
    check_element_on_top(SourceStack, Element, RestSource),

    % Append the element to the destination stack
    append(DestStack, [Element], NewDestStack),

    % Rebuild the stacks with updated Source and Destination
    update_stack_at_index(StacksBefore, SourceIndex, RestSource, TempStacks),
    update_stack_at_index(TempStacks, DestIndex, NewDestStack, StacksAfter),

    % Print status before and after the move
    print_before_after(StacksBefore, StacksAfter).

moveblock(StacksBefore, Element, SourceIndex, DestIndex) :-
    moveblock(StacksBefore, _, Element, SourceIndex, DestIndex).




% Sort Blocks

% Main predicate: Sort blocks across three stacks
order_blocks(UnsortedStack, SortedStack, NumberOfMoves) :-
    order_blocks_helper(UnsortedStack, [[], [], []], 0, SortedStack, NumberOfMoves).

% Recursive helper to sort blocks
order_blocks_helper([[], [], []], CurrentStack, Moves, CurrentStack, Moves) :- !. % Base case: all stacks empty

order_blocks_helper(UnsortedStack, CurrentStack, MoveCount, SortedStack, NumberOfMoves) :-
    % Find the smallest block that is on top of a stack
    find_smallest_top_block(UnsortedStack, SmallestBlock, SourceIndex),

    % Decide which stack to move the smallest block to
    choose_target_stack(CurrentStack, TargetIndex),

    % Move the smallest block to the chosen stack
    moveblockNoRestriction(UnsortedStack, TempStack, SmallestBlock, SourceIndex, TargetIndex),

    % Update the current stack with the result of the move
    update_current_stack(CurrentStack, TargetIndex, SmallestBlock, UpdatedStack),

    % Increment the move counter
    NewMoveCount is MoveCount + 1,

    % Print the status after the move
    print_before_after(UnsortedStack, TempStack),

    % Continue sorting recursively
    order_blocks_helper(TempStack, UpdatedStack, NewMoveCount, SortedStack, NumberOfMoves).

% Find the smallest block among the top elements of non-empty stacks
find_smallest_top_block(Stacks, SmallestBlock, StackIndex) :-
    findall(Top-Index, (nth1(Index, Stacks, Stack), Stack = [Top|_]), TopsWithIndices),
    keysort(TopsWithIndices, [SmallestBlock-StackIndex|_]).

% Decide which stack to move a block to
choose_target_stack(Stacks, TargetIndex) :-
    (nth1(TargetIndex, Stacks, Stack), Stack == [] -> true ; TargetIndex = 1).

% Update the current stack configuration
update_current_stack(CurrentStack, TargetIndex, Block, UpdatedStack) :-
    nth1(TargetIndex, CurrentStack, DestStack),
    append(DestStack, [Block], NewDestStack),
    update_stack_at_index(CurrentStack, TargetIndex, NewDestStack, UpdatedStack).

% Move a block with no restrictions
moveblockNoRestriction(StacksBefore, StacksAfter, Element, SourceIndex, DestIndex) :-
    % Get source and destination stacks
    nth1(SourceIndex, StacksBefore, SourceStack),
    nth1(DestIndex, StacksBefore, DestStack),

    % Remove the element from the source stack
    select(Element, SourceStack, RestSource),

    % Append the element to the destination stack
    append(DestStack, [Element], NewDestStack),

    % Rebuild the stacks with updated Source and Destination
    update_stack_at_index(StacksBefore, SourceIndex, RestSource, TempStacks),
    update_stack_at_index(TempStacks, DestIndex, NewDestStack, StacksAfter).

% Update a stack at a specific index
update_stack_at_index([_|T], 1, NewElement, [NewElement|T]).
update_stack_at_index([H|T], N, NewElement, [H|R]) :-
    N > 1,
    N1 is N - 1,
    update_stack_at_index(T, N1, NewElement, R).

% Print "before" and "after" stacks
print_before_after(StacksBefore, StacksAfter) :-
    write('Before:\n'),
    print_stacks(StacksBefore),
    write('After:\n'),
    print_stacks(StacksAfter).

% Print stacks in a readable format
print_stacks(Stacks) :-
    maplist(print_stack, Stacks).

% Print a single stack
print_stack([]) :-
    write('| |\n').
print_stack(Stack) :-
    write('|'),
    maplist(write_element, Stack),
    write('\n').

% Print a stack element
write_element(Element) :-
    write(Element),
    write('|').













