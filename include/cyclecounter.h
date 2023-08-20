#ifndef CYCLECOUNTER_H
#define CYCLECOUNTER_H

#if 0
#include <stm32f7xx.h>

class CycleCounter
{
public:
	CycleCounter() {
		CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
    	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
	}

	~CycleCounter() {
		DWT->CTRL = 0;
	}

	void start() {
		m_end = 0;
		DWT->CYCCNT = 0;
	}

	void stop() {
		DWT->CTRL = 0;
		m_end = DWT->CYCCNT;
	}

	uint32_t count() const {
		return m_end;
	}
private:
	uint32_t m_end = 0;
};
#else

#include <inttypes.h>

void CycleCounterStart(void);
uint32_t CycleCounterStop(void);

#endif
#endif
