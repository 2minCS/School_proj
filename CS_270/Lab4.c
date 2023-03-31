#include <stdio.h>
#include <stdlib.h>
 
int main()
{
 
    // This pointer will hold the
    // base address of the block created
    int* ptr;
    int* ptr2;
    int n, i, r;
 
    // Get the number of elements for the array
    printf("Enter number of elements:");
    scanf("%d",&n);
    printf("Entered number of elements: %d\n", n);
 
    // Dynamically allocate memory using malloc()
    ptr = (int*)malloc(n * sizeof(int));
    ptr2 = (int*)calloc(n, sizeof(int)); 
    // Check if the memory has been successfully
    // allocated by malloc or not
    if (ptr == NULL) {
        printf("Memory not allocated.\n");
        exit(0);
    }
    else {
 
        // Memory has been successfully allocated
        printf("Memory successfully allocated using malloc.\n");
        printf("\n\nEnter the new size of the array: ");
        scanf("%d",&r);
        // Dynamically re-allocate memory using realloc()
        ptr = realloc(ptr, r * sizeof(int));
 
        // Memory has been successfully allocated
        printf("Memory successfully re-allocated using realloc.\n");
        free(ptr);
        printf("Malloc Memory successfully freed.\n");
        printf("Memory successfully allocated using calloc.\n");
        free(ptr2);
        printf("Calloc Memory successfully freed.\n");
        // Get the elements of the array
        for (i = 0; i < r; ++i) {
            ptr[i] = i + 1;
        }
        for (i = 0; i < n; ++i) {
            ptr2[i] = i + 1;
        }
 
        // Print the elements of the array
        printf("The elements of the malloc array are: ");
        for (i = 0; i < r; ++i) {
            printf("%d, ", ptr[i]);
        }
        printf("\nThe elements of the calloc array are: ");
        for (i = 0; i < n; ++i) {
            printf("%d, ", ptr2[i]);
        }
    }
 
    return 0;
}
