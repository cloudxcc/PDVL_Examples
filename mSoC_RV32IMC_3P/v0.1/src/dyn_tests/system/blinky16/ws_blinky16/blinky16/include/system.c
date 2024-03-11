//
// Copyright 2023 Tobias Strauch, Munich, Bavaria, Germany
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
#define GPIO_0_DIR_CLR    (*((volatile unsigned long*) 0x80030000))
#define GPIO_0_DIR_SET    (*((volatile unsigned long*) 0x80030004))
#define GPIO_0_TRI_CLR    (*((volatile unsigned long*) 0x80030008))
#define GPIO_0_TRI_SET    (*((volatile unsigned long*) 0x8003000C))
#define GPIO_0_OUT_CLR    (*((volatile unsigned long*) 0x80030010))
#define GPIO_0_OUT_SET    (*((volatile unsigned long*) 0x80030014))
#define GPIO_0_IN         (*((volatile unsigned long*) 0x80030020))

#define GPIO_1_DIR_CLR    (*((volatile unsigned long*) 0x80030100))
#define GPIO_1_DIR_SET    (*((volatile unsigned long*) 0x80030104))
#define GPIO_1_TRI_CLR    (*((volatile unsigned long*) 0x80030108))
#define GPIO_1_TRI_SET    (*((volatile unsigned long*) 0x8003010C))
#define GPIO_1_OUT_CLR    (*((volatile unsigned long*) 0x80030110))
#define GPIO_1_OUT_SET    (*((volatile unsigned long*) 0x80030114))
#define GPIO_1_IN         (*((volatile unsigned long*) 0x80030120))

#define UART_SEND         (*((volatile unsigned long*) 0x80020000))
#define UART_TX_COM       (*((volatile unsigned long*) 0x80020010))
#define UART_REC          (*((volatile unsigned long*) 0x80020020))
#define UART_RX_COM       (*((volatile unsigned long*) 0x80020030))

