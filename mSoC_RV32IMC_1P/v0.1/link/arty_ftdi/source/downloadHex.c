#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#ifdef __WIN32__
#define _WINDOWS
#define usleep(x) Sleep(x/1000 +1)
#include <windows.h>
#endif
#include <ftd2xx.h>

FILE *hex;
const unsigned programOffset = 0x00010000;
const unsigned programSize = 0xc00;
char program [0xc00];

/////////////////////////////////////////////////////////////////////////////////
//	readHex
/////////////////////////////////////////////////////////////////////////////////
unsigned readHex ()
{
   int c;
   int stat1 = 0;
   unsigned ptr = 0;
   int count = 0;
   while (1)
   {
      c = getc(hex);
      if (c == -1)
      {
         break;
      }
      if (   (c == '\n') |
             (c == 13)   |
             (c == 10)   )
      {
         if (stat1 == 1)
         {          
            ptr = count;
            if (ptr >= programOffset + programSize)
              break;
            stat1 += 1;
         }
      } else
      if (   (c == ' ')   )
      {
         if (stat1 == 1)
         {
            ptr = count;      
            if (ptr >= programOffset + programSize)
               break;
            stat1 += 1;
         } else
         {
            program[ptr - programOffset] = count;
            ptr += 1;
           if (ptr >= programOffset + programSize)
              break;
         }
         count = 0;
      } else
      if (c == '@')
      {
         if (stat1 == 1)
            break;
         stat1 += 1;
      } else
      {
         if (c < 58)
            count = count * 16 + (c - 48);
         else
            count = count * 16 + (c - 55);
      }
   }
   return ptr;
}

/////////////////////////////////////////////////////////////////////////////////
//	sendVerify
/////////////////////////////////////////////////////////////////////////////////
void sendVerify (FT_HANDLE ftHandle, int ptr)
{
   DWORD BytesWritten,BytesReturn,RxBytes,TxBytes,EventWord; 

   Sleep (20);   

   FT_STATUS ftStatus = FT_GetStatus(ftHandle,&RxBytes,&TxBytes,&EventWord);

   char RxBuffer[15];

   if (RxBytes > 0)
   {
      ftStatus = FT_Read(ftHandle,RxBuffer,RxBytes,&BytesReturn);

      if(ftStatus != FT_OK)
      {
         fprintf(stderr, "Error: Receiving error during sendVerify.\n");
         //return -255;
      }

      for (int i = 0; i < RxBytes; i++)
      {
         if (program[ptr + i] != RxBuffer[i])
         {
            printf("Pattern mismatch: send: %2.2x received: %2.2x\n",program[ptr + i] & 0xff, RxBuffer[i] & 0xff);
         }
      }
   }
}

/////////////////////////////////////////////////////////////////////////////////
//	main
//	Original source: http://www.b-redemann.de/sp-DMM-auslesen.shtml
/////////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
   // init
   FT_HANDLE ftHandle;
   FT_STATUS ftStatus;
   DWORD BytesWritten,BytesReturn,RxBytes,TxBytes,EventWord; 

   ftStatus = FT_Open(1, &ftHandle);
   if(ftStatus != FT_OK)
   {
      fprintf(stderr, "Error: Unable to open ftdi device.\n");
      return -255;
   }
   //ftStatus = FT_SetBaudRate(ftHandle, 5000000); // Set baud rate to 115200 
   ftStatus = FT_SetBaudRate(ftHandle, 115200); // Set baud rate to 115200 

   if(ftStatus != FT_OK)
   {
      fprintf(stderr, "Error: Unable to set baudrate.\n");
      return -255;
   }

   ftStatus = FT_SetDataCharacteristics(ftHandle, FT_BITS_8, FT_STOP_BITS_1, FT_PARITY_NONE);

   if(ftStatus != FT_OK)
   {
     fprintf(stderr, "Error: Unable to set data characteristics.\n");
     return -255;
   }

   if (1)
   {
      printf("Set Reset\n");
      char ToSend1[1] = {0x11};
      FT_Write(ftHandle,ToSend1,1,&BytesWritten);
      Sleep (1);
   }

   printf("Programming ...\n");
   int ptr_offset = 0x00010000;
   if (1)
   {
      for (int c = 0; c < 1; c++)
      {
         if (1)
         {
            hex = fopen("../../../../src/dyn_tests/system/blinky16/work/main_0.hex","r"); 
            for (int tmpPtr = 0; tmpPtr < 400; tmpPtr = tmpPtr + 4) 
            {
               program[tmpPtr + 0] = 0x13;
               program[tmpPtr + 1] = 0;
               program[tmpPtr + 2] = 0;
               program[tmpPtr + 3] = 0;
            }

            unsigned length = (readHex() - programOffset) / 256;
            
            for (int tmpPtr = 0; tmpPtr < 300; tmpPtr = tmpPtr + 4) 
            {
               //printf("Programming %d\n", tmpPtr);
               //uart_send(8'h30);               // 0x30 memory programming
               char ToSend1[1] = {0x30};
               FT_Write(ftHandle,ToSend1,1,&BytesWritten);
               Sleep (1);

               //uart_send((i >> 2) & 0xff);
               char ToSend2[1] = {(tmpPtr >> 2) & 0xff};
               FT_Write(ftHandle,ToSend2,1,&BytesWritten);
               Sleep (1);

               //uart_send(i >> 10);
               char ToSend3[1] = {(tmpPtr >> 10) & 0xff};
               FT_Write(ftHandle,ToSend3,1,&BytesWritten);
               Sleep (1);

               //printf("Programming %d: %2x %2x %2x %2x\n", tmpPtr, program[tmpPtr + 3] & 0xff, program[tmpPtr + 2] & 0xff, program[tmpPtr + 1] & 0xff, program[tmpPtr] & 0xff);
               //uart_send(program[i]);
               char ToSend4[1] = {program[tmpPtr] & 0xff};
               FT_Write(ftHandle,ToSend4,1,&BytesWritten);
               Sleep (1);

               //uart_send(program[i + 1]);
               char ToSend5[1] = {program[tmpPtr + 1] & 0xff};
               FT_Write(ftHandle,ToSend5,1,&BytesWritten);
               Sleep (1);

               //uart_send(program[i + 2]);
               char ToSend6[1] = {program[tmpPtr + 2] & 0xff};
               FT_Write(ftHandle,ToSend6,1,&BytesWritten);
               Sleep (1);

               //uart_send(program[i + 3]);
               char ToSend7[1] = {program[tmpPtr + 3] & 0xff};
               FT_Write(ftHandle,ToSend7,1,&BytesWritten);
               Sleep (1);
            }
         }
      }
   } 

   if (1)
   {
      printf("Clear Reset\n");
      char ToSend1[1] = {0x10};
      FT_Write(ftHandle,ToSend1,1,&BytesWritten);
      Sleep (1);
   }
   
   // right now a little bug requires a 2nd reset
   if (1)
   {
      printf("Set Reset\n");
      char ToSend1[1] = {0x11};
      FT_Write(ftHandle,ToSend1,1,&BytesWritten);
      Sleep (1);
   }
   
   if (1)
   {
      printf("Clear Reset\n");
      char ToSend1[1] = {0x10};
      FT_Write(ftHandle,ToSend1,1,&BytesWritten);
      Sleep (1);
   }
   
   // Finish
   FT_Close(ftHandle);

   fprintf(stdout, "Program downloadHex finished.\n");
   return 0;
}
