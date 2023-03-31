#include <stdio.h>
 
void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}
 
void selectionSort(int arr[], int n)
{
    int i, j, min_idx;
 
    // One by one move boundary of unsorted subarray
    for (i = 0; i < n-1; i++)
    {
        // Find the minimum element in unsorted array
        min_idx = i;
        for (j = i+1; j < n; j++)
          if (arr[j] < arr[min_idx])
            min_idx = j;
 
        // Swap the found minimum element with the first element
        swap(&arr[min_idx], &arr[i]);
    }
}
 
/* Function to print an array */
void printArray(int arr[], int size)
{
    int i;
    for (i=0; i < size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}
void writeArryToFile(int arr[], int size, FILE* demo)
{
    int i;
    for(i = 0; i< size; i++)
    {
        
        for(i = 0; i<5; i++)
        {
            fprintf(demo, "%i ", arr[i]);
        }
        printf("\n");
    fclose(demo);
    }


    printf("Array written to file.\n");
}
// Driver program to test above functions
int main()
{
    FILE* demo;
    demo = fopen("file.txt", "w+");
    int arr[] = {64, 25, 12, 22, 11};
    int n = sizeof(arr)/sizeof(arr[0]);
    printf("Un-sorted array: \n");
    printArray(arr,n);
    selectionSort(arr, n);
    printf("Sorted array: \n");
    printArray(arr, n);
    writeArryToFile(arr, n, demo);
    return 0;
}