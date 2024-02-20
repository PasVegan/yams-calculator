# yams-calculator
Tool written in Zig to compute probabilities for the yams game


## How to build:
```
make or make debug
```

#### How to use:
```
USAGE  
    ./yams d1 d2 d3 d4 d5 c cd1 [cd2]
DESCRIPTION
    d1    value of the first die (0 if not thrown)
    d2    value of the second die (0 if not thrown)
    d3    value of the third die (0 if not thrown)
    d4    value of the fourth die (0 if not thrown)
    d5    value of the fifth die (0 if not thrown)
    c     combination to be obtained
    cd1   first dice in combination
    [cd2] second dice in combination (if applicable)
```

The following combination are implemented: where A and B are the values of the dice in the combination
- pair_A
- three_A
- four_A
- full_A_B
- straight_A
- yams_A


#### Examples:
```
./yams 1 2 5 1 4 straight_5

./yams 0 0 0 0 0 yams_3

./yams 1 2 3 4 5 three_1

./yams 5 0 0 4 0 full_1_2
```