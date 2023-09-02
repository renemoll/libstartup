
#include "cyclecounter.h"
#include <stm32f7xx.h>

void CycleCounterStart()
{
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->LAR = 0xC5ACCE55;
	DWT->CYCCNT = 0;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}

uint32_t CycleCounterStop()
{
	DWT->CTRL = 0;
	return DWT->CYCCNT;
}
