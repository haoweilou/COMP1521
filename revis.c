#include<stdio.h>
int main(void)
{
    int n, a, b, c;
    n = scanf("%d %d %d", &a, &b, &c);
    for(int i = 1 << 15; i > 0; i = i >> 1)
    {
        int an = i&a;
        if(an > 0)
        {
            printf("1");
        }
        else
        {
            printf("0");
        }
    }printf("\n");
    
    for(int i = 1 << 15; i > 0; i = i >> 1)
    {
        int bn = i&b;
        if(bn> 0)
        {
            printf("1");
        }
        else
        {
            printf("0");
        }
    }printf("\n");
    
    for(int i = 1 << 15; i > 0; i = i >> 1)
    {
        int cn = i&c;
        if(cn> 0)
        {
            printf("1");
        }
        else
        {
            printf("0");
        }
    }printf("\n");
    
    
    n = printf("%d %d %d,%d\n",a,b,c,n);
    printf("%d\n",n);
    return 0;
}
