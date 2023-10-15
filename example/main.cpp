
#include "timeout.h"

#include "stm32f7xx_ll_bus.h"
#include "stm32f7xx_ll_gpio.h"

#include <cinttypes>


//! \todo LL API
uint32_t SystemCoreClock = 16000000;

void initGpio()
{
	LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOB);

	LL_GPIO_InitTypeDef init = {};
	LL_GPIO_StructInit(&init);
	init.Pin = LL_GPIO_PIN_7;
	init.Mode = LL_GPIO_MODE_OUTPUT;
	LL_GPIO_Init(GPIOB, &init);
	LL_GPIO_ResetOutputPin(GPIOB, LL_GPIO_PIN_7);
}

int main() {
	initGpio();

	const auto ticks = (SystemCoreClock / 1000U) - 1;
	SysTick_Config(ticks);
	__enable_irq();

	while(true) {
		if (g_timer.triggered())
			LL_GPIO_TogglePin(GPIOB, LL_GPIO_PIN_7);
	}
}

extern "C" {
void SysTick_Handler()
{
	g_timer.increment();
}
}
