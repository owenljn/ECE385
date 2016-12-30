#include <stdio.h>
#include <stdlib.h>
#include <string.h>
const char *chartomorse(char);

// Function for user to choose the preferred printing color
int color(){
  
  char color[100]="";
  printf("Please choose a color ( red / green ): \n");
  fgets(color,10,stdin);
  if (strcmp(color, "red\n")==0) {
    return 0;
  } 
  return 1;
}
char* strinkify(){
  char text[100]="";
  printf("Enter the text to be encoded: \n");
  fgets(text, 100, stdin);

  int i = 0;
  char output[300] = "";
  // This while loop converts characters in string and put them together into output
  while(text[i]!='\0') {
    const char *morse = chartomorse(text[i]);
    strcat(output,morse);
    i++;
  }
  printf("The converted output is: %s\n", output);
  return output;
}

// Function to convert a char into morse form
const char *chartomorse(char c){
    // Use a char to morse mapping to make it easy to translate
    char *charArray = "abcdefghijklmnopqrstuvwqyz"; 
    const char* morse[26] = {".-","-...","-.-.","-..", ".", "..-.", "--.",
                      "....", "..", ".---", "-.-", ".-..", "--",
                      "-.", "---", ".--.", "--.-", ".-.", "...", "-",
                      "..-", "...-", ".--", "-..-", "-.--", "--.."};
    int index = 0;
    while (index <= 25) {
	if (charArray[index] == c) {
		break;
	}
	index++;
    }
    // Set index to -1 if space is found
    if (index == 0 && c != 'a') {
	index = -1;
    }
    // Use a larger space to represent the morse form of the space
    const char *space = "  ";
    
    if(index<=25) {
        return morse[index];
    } return space; // return a large space since a space is found
}
