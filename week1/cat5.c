//Haowei Lou
//z5258575
//2019 JUN 04
#include <stdio.h>
#include <stdlib.h>

static void copy (FILE *, FILE *);

int main(int argc, char *argv[])
{
    FILE *f;
    if (argc == 1)
    {
        copy(stdin, stdout);
    }
    else
    {
        for (int i = 1; i < argc; )
        {
            f = fopen(argv[i],"r");
            if (f != NULL)
            {                
                copy(f , stdout);
                fclose(f);
            }
            else
            {
                printf("Can't read %s\n",argv[i]);
            }
            i++;
        }  
    }
    return EXIT_SUCCESS;
}

// Copy contents of input to output, char-by-char
// Assumes both files open in appropriate mode
static void copy (FILE *input, FILE *output)
{
    char array[BUFSIZ];
    
    while(fgets(array, BUFSIZ, input) != NULL) {
        fputs(array, output);
    }
}
