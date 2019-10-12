#include<stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(void) {
    int fd = open("xyz", O_RDONLY);
    if (fd < 0) {
        perror(NULL);
    }
    return 0;
}