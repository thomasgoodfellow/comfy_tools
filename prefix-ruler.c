// prefix-ruler.c
// 
// Passes STDIN to STDOUT (using cat), first prefixing with a simple ruler as
// wide as the current console (or 130 cols if width can't be determined)

#include <sys/ioctl.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

int main(void)
{
    struct winsize w;
    if(ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == -1)
    {
        w.ws_col = 130;
    }
    for(int c = 10; c < w.ws_col; c += 10)
    {
        printf("%10d", c / 10);
    }
    printf("\n");
    for(int c = 1; c < w.ws_col; ++c)
    {
        printf("%c", c % 10 == 0? '0': 
               c % 5 == 0? '+': '.');
    }
    printf("\n");
    fflush(stdout);

    if(execl("/bin/cat", "/bin/cat", "-", NULL) == -1)
    {
        printf("err = %d when starting cat\n", errno);
    }
    return 0;
}
