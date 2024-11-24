% Print a row
print_row([]).
print_row([Element]):- write('|'),write(Element), write('|').
print_row([Element | NextElement]):- write('|'), write(Element), print_row(NextElement).

print_status([]).
print_status([Row | NextRow]):- print_row(Row), nl, print_status(NextRow).