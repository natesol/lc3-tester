// 
// gcc Assembly_sol.c -Wall -Wextra -pedantic-errors -o main
// 

#include <stdio.h>
#include <stdlib.h>

#define MAX 30

int GetNum ();
void PrintNum (int);
void printQueensPositions (int*,int);
int NQueenSolver (int,int*,int,int);


int main () {
    int positions[MAX] = { 0 };
    int N = GetNum();
    int solutions = NQueenSolver(0, positions, 0, N);
    printf("%d", solutions);
    
    return 0;
}

int GetNum () {
    int num;

    printf("Enter N, i.e., number between 1 to 30: ");
    scanf("%d", &num);
    
    if ( num > 30 || num < 0 ) {
        printf("N is out of range.");
        exit(-1);
    }
    
    return num;
}

void PrintNum (int num) {
    printf("%d", num);
}

void printQueensPositions (int positions[], int N) {
    for ( int i = 0 ; i < N ; i++ ) {
        printf("%d", positions[i]);
        printf(" ");
    }
    printf("\n");
}

int isLegal (int queen_number, int positions[], int col_position) {
    if ( queen_number == 0 ) {
        return 1;
    }
    
    int i = queen_number - 1;
    while ( i >= 0 ) {
        if ( positions[i] - col_position == 0 ) {
            return 0;
        }
        if ( positions[i] - (col_position - (queen_number - i)) == 0 ) {
            return 0;
        }
        if ( positions[i] - (col_position + (queen_number - i)) == 0 ) {
            return 0;
        }
        i--;
    }
    return 1;
}

int NQueenSolver (int queen_number, int positions[], int solutions, int N) {
    int R0 = solutions;

    if ( queen_number - N == 0 ) {
        printQueensPositions(positions, N);
        R0 += 1;
        return R0;
    }

    int i = 0;
    while ( i - N != 0 ) {
        R0 = isLegal(queen_number, positions, i);
        if ( R0 != 0 ) {
            positions[queen_number] = i;
            R0 = NQueenSolver(queen_number + 1, positions, solutions, N);
            solutions = R0;
        }
        i++;
    }

    R0 = solutions;
    return R0;
}