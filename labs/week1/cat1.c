// COMP1521 19T2 ... lab 1
// cat1: Copy input to output
//Haowei Lou
//z5258575
//2019 JUN 04

#include <stdio.h>
#include <stdlib.h>

static void copy (FILE *, FILE *);

int main (int argc, char *argv[])
{
	copy (stdin, stdout);
	return EXIT_SUCCESS;
}

// Copy contents of input to output, char-by-char
// Assumes both files open in appropriate mode
static void copy (FILE *input, FILE *output)
{
    char ch;
    int a = fscanf(input, "%c", &ch);
    while(a != EOF)
    {
        fprintf(output, "%c", ch);
        a = fscanf(input, "%c", &ch);
    }
    return;
}
