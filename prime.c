#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void prime(int start, int finish)
{

    int fd = open("prime_number.txt", O_CREATE | O_RDWR);
    if (fd != -1)
    {
        unlink("prime_number.txt");
        fd = open("prime_number.txt", O_CREATE | O_RDWR);
    }

    char buf[20];

    for (int i = start; i <= finish; i++)
    {
        int x = 0;
        int flag = 1;
        for (int j = 2; j < i - 1; j++)
        {
            if (i % j == 0)
            {
                flag = 0;
                break;
            }
        }
        if (i <= 1)
            flag = 0;

        if (flag == 1)
        {
            int res = i;
            while (res != 0)
            {
                buf[x++] = '0' + res % 10;
                res /= 10;
            }

            while (x-- >= 0)
            {
                write(fd, &buf[x], sizeof(char));
            }

            write(fd, " ", sizeof(char));
        }
    }
    write(fd, "\n", sizeof(char));
    close(fd);
}

int main(int argc, char *argv[])
{
    prime(atoi(argv[1]), atoi(argv[2]));
    exit();
}