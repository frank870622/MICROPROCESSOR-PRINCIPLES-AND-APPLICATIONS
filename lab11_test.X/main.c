#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"

void clearString();
void Mylab10_2();

char modeStr[10] ;
int lenStr;

void main(void) {
    
    SYSTEM_Initialize() ;
    
    while(1);
    return;
    
}

void Mode1()
{
    LED1_SetDigitalOutput();
    LED1_Toggle();
    clearString();
    return ;
}

void clearString() {
    for(int i = 0; i < 10 ; i++)
        modeStr[i] = '\0';
    lenStr = 0;
}
