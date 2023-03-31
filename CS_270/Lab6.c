#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define BUFFER 15
int main(void)
{
    char buff[BUFFER];
    int pass = 0;
    
    printf("\n Enter the password : \n");
    fgets(buff, BUFFER, stdin);
    buff[strlen(buff)-1]='\0';
    printf("The string is: %s\n", buff);
  
     if(strncmp(buff, "thegeekstuff", BUFFER))
    {
        printf ("\n Wrong Password \n");
    }
    else
    {
        printf ("\n Correct Password \n");
        pass = 1;
    }

    if(pass)
    {
       /* Now Give root or admin rights to user*/
        printf ("\n Root privileges given to the user \n");
    }

    return 0;
}