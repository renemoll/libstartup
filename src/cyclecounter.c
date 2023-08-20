
#include "cyclecounter.h"
#include <stm32f7xx.h>

void CycleCounterStart()
{
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
	DWT->CYCCNT = 0;
}

uint32_t CycleCounterStop()
{
	DWT->CTRL = 0;
	return DWT->CYCCNT;
}
