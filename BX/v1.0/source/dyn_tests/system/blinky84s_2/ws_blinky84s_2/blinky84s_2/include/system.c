//
// Copyright 2023 Tobias Strauch, Munich, Bavaria, Germany
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

#define TC_START          (*((volatile unsigned long*) 0x00000400))
#define TC_KILL           (*((volatile unsigned long*) 0x00000404))

#define CA_CT             (*((volatile unsigned long*) 0x00000408))

#define GPIO_0_DIR_CLR    (*((volatile unsigned long*) 0x00000440))
#define GPIO_0_DIR_SET    (*((volatile unsigned long*) 0x00000444))
#define GPIO_0_TRI_CLR    (*((volatile unsigned long*) 0x00000448))
#define GPIO_0_TRI_SET    (*((volatile unsigned long*) 0x0000044C))
#define GPIO_0_OUT_CLR    (*((volatile unsigned long*) 0x00000450))
#define GPIO_0_OUT_SET    (*((volatile unsigned long*) 0x00000454))
#define GPIO_0_IN         (*((volatile unsigned long*) 0x00000460))

#define GPIO_1_DIR_CLR    (*((volatile unsigned long*) 0x00000480))
#define GPIO_1_DIR_SET    (*((volatile unsigned long*) 0x00000484))
#define GPIO_1_TRI_CLR    (*((volatile unsigned long*) 0x00000488))
#define GPIO_1_TRI_SET    (*((volatile unsigned long*) 0x0000048C))
#define GPIO_1_OUT_CLR    (*((volatile unsigned long*) 0x00000490))
#define GPIO_1_OUT_SET    (*((volatile unsigned long*) 0x00000494))
#define GPIO_1_IN         (*((volatile unsigned long*) 0x000004A0))

#define GPIO_2_DIR_CLR    (*((volatile unsigned long*) 0x000004C0))
#define GPIO_2_DIR_SET    (*((volatile unsigned long*) 0x000004C4))
#define GPIO_2_TRI_CLR    (*((volatile unsigned long*) 0x000004C8))
#define GPIO_2_TRI_SET    (*((volatile unsigned long*) 0x000004CC))
#define GPIO_2_OUT_CLR    (*((volatile unsigned long*) 0x000004D0))
#define GPIO_2_OUT_SET    (*((volatile unsigned long*) 0x000004D4))
#define GPIO_2_IN         (*((volatile unsigned long*) 0x000004E0))

#define GPIO_3_DIR_CLR    (*((volatile unsigned long*) 0x00000500))
#define GPIO_3_DIR_SET    (*((volatile unsigned long*) 0x00000504))
#define GPIO_3_TRI_CLR    (*((volatile unsigned long*) 0x00000508))
#define GPIO_3_TRI_SET    (*((volatile unsigned long*) 0x0000050C))
#define GPIO_3_OUT_CLR    (*((volatile unsigned long*) 0x00000510))
#define GPIO_3_OUT_SET    (*((volatile unsigned long*) 0x00000514))
#define GPIO_3_IN         (*((volatile unsigned long*) 0x00000530))

#define GPIO_4_DIR_CLR    (*((volatile unsigned long*) 0x00000540))
#define GPIO_4_DIR_SET    (*((volatile unsigned long*) 0x00000544))
#define GPIO_4_TRI_CLR    (*((volatile unsigned long*) 0x00000548))
#define GPIO_4_TRI_SET    (*((volatile unsigned long*) 0x0000054C))
#define GPIO_4_OUT_CLR    (*((volatile unsigned long*) 0x00000550))
#define GPIO_4_OUT_SET    (*((volatile unsigned long*) 0x00000554))
#define GPIO_4_IN         (*((volatile unsigned long*) 0x00000570))

