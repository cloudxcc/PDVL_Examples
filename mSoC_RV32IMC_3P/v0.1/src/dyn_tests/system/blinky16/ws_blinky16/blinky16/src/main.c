//
// Copyright 2023 Tobias Strauch, Munich, Bavaria, Germany
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

#define DMEM    (*((volatile unsigned long*) 0x00000010))

#include "system.c"

int main(void)
{
   DMEM = 0x01234567;
   while (!(DMEM == 0x01234567));
   GPIO_1_DIR_SET = 0x01;
   if (1) {
	   for (unsigned i = 0; i < 20; i++) {
		   for (unsigned ii = 0; ii < 2; ii++) {
			   for (unsigned iii = 0; iii < 2; iii++) {
     		       GPIO_1_OUT_SET = 0xff;
			   }
			   for (unsigned iii = 0; iii < 2; iii++) {
     		       GPIO_1_OUT_CLR = 0xff;
			   }
		   }
	   }
   }
   while (1) {
	   for (unsigned i = 0; i < 1000; i++) {
		   for (unsigned ii = 0; ii < 1000; ii++) {
			   for (unsigned iii = 0; iii < 5; iii++) {
     		       GPIO_1_OUT_SET = 0x01;
			   }
		   }
	   }
	   for (unsigned i = 0; i < 1000; i++) {
		   for (unsigned ii = 0; ii < 1000; ii++) {
			   for (unsigned iii = 0; iii < 5; iii++) {
     		       GPIO_1_OUT_CLR = 0x01;
			   }
		   }
	   }
   }

}
