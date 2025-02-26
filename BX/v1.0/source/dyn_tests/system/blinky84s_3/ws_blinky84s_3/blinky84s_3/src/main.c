//
// Copyright 2023 Tobias Strauch, Munich, Bavaria, Germany
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

#include "system.c"

#define DMEM    (*((volatile unsigned long*) 0x00000010))

#define CYCLE 224 // 7 * 32

void gpio_0 (int bit) {
   unsigned CYCLE_A = CYCLE;
   for (unsigned i = 0; i < bit; i++) {
   	   CYCLE_A += 7;
   }
   bit &= 0x7;
   //for (unsigned l = 0; l < 2; l++) {
   while (1) {
	   for (unsigned i = 0; i < CYCLE_A; i++) {
		   for (unsigned ii = 0; ii < CYCLE; ii++) {
			   for (unsigned iii = 0; iii < CYCLE; iii++) {
				   GPIO_0_DIR_SET = 0x01 << (bit >> 1); // dummy
			   }
		   }
	   }
	   if (bit & 0x1)
          GPIO_0_OUT_CLR = 0x01 << (bit >> 1);
	   else
          GPIO_0_OUT_SET = 0x01 << (bit >> 1);
	   /*
	   for (unsigned i = 0; i < CYCLE; i++) {
		   for (unsigned ii = 0; ii < CYCLE; ii++) {
			   for (unsigned iii = 0; iii < CYCLE; iii++) {
     		       GPIO_0_OUT_CLR = 0x01 << bit;
			   }
		   }
	   }
	   */
	   CYCLE_A = CYCLE;
   }
   if (bit > 0) TC_KILL = 0x1;
}

void gpio_0_thread_0(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 0);
	}
}

void gpio_0_thread_1(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 1);
	}
}

void gpio_0_thread_2(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 2);
	}
}

void gpio_0_thread_3(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 3);
	}
}

void gpio_0_thread_4(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 4);
	}
}

void gpio_0_thread_5(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 5);
	}
}

void gpio_0_thread_6(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(24 + 6);
	}
}
/*
void gpio_0_thread_7(int start_time) {
	if (start_time >= 0) {
		//TC_START = 0xc0000000 + (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
		TC_START = (((unsigned)&&gpio_0_label >> 1) & 0x3ff);
	} else
	{
		gpio_0_label:
		   gpio_0(7);
	}
}
*/
int main(void)
{
   DMEM = 0x01234567;
   while (!(DMEM == 0x01234567));
   //GPIO_1_DIR_SET = 0xff;
   unsigned CT = CA_CT;
   /*
   gpio_0_thread_1(CT);
   gpio_0_thread_2(CT);
   gpio_0_thread_3(CT);
   gpio_0(0);
   gpio_0(0);
   gpio_0_thread_1(CT);
   gpio_0_thread_2(CT);
   gpio_0_thread_3(CT);
   gpio_0_thread_4(CT);
   gpio_0(0);
   gpio_0(0);
   */
   gpio_0_thread_0(CT);
   gpio_0_thread_1(CT);
   gpio_0_thread_2(CT);
   gpio_0_thread_3(CT);
   gpio_0_thread_4(CT);
   gpio_0_thread_5(CT);
   gpio_0_thread_6(CT);
   //gpio_0_thread_7(CT);
   gpio_0(24 + 7);
   //gpio_0(0);
   //GPIO_0_OUT_SET = 0x55;
   //GPIO_1_DIR_SET = 0xff;
   //GPIO_1_OUT_SET = ~GPIO_0_IN;
}
