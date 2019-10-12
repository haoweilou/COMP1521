#include<stdio.h>
#include "Stack.h"

int main(void) {
    Stack s;
    int a;
    initStack(&s);
    while(scanf("%d", &a)==1) {
        if(a < 0) break;
        if (!pushStack(&s,a)) break;
        printStack(&s);
    }
    //printf("Now we pop\n");
    while(!isEmpty(&s)) {
        popStack(&s);
        printStack(&s);
    }
    return 0;
}
