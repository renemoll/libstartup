
#include "system.h"

#include <algorithm>
#include <cinttypes>

#include <stm32f7xx.h>

uint32_t SystemCoreClock = 16000000;

/*
 * It is assumed that this function is called from the Reset exception handler. Impling that
 * the processor has already performed the following actions [1]: 
 * - the CPU:
 *   - clars it's local registers;
 *   - LR is set to an invalid value (0xFFFFFFFF);
 *   - switched to **Thread** execution mode.
 * - the NVIC:
 *   - clears all active/pending/enabled exceptions and priorities.
 * - the FPU (if available):
 *   - is disabled and reset.
 * - the MPU:
 *   - is disabled (note: not all registers are cleared).
 * - the SysTick:
 *   - is disabled (note: not all registers are cleared).
 * - the System:
 *   - clears the control block registers; 
 *     note: this means the vector table address (VTOR) is also reset to 0x00000000.
 *   - clears the special registers for exception priority boosting (PRIMASK, FAULTMASK, BASEPRI);
 *   - the main stack pointer is set to vector table entry #0.
 *   - clears any registered event (WFE related);
 *   - clears any monitor state (related to exclusive access to shareable memory)
 * - finally, the CPU branches to the reset exception hander
 *
 * This leaves the start-up code to:
 * - re-enabling the FPU/MPU;
 * - initializing the C/C++ runtime:
 *   - copy initial values from FLASH to RAM (data section);
 *   - zero initialize variables in RAM (bss section);
 *   - call static constructors/initializers.
 * - configure the vector table address (VTOR).
 * - enable caches?
 *
 * [1] Arm®v7-M Architecture Reference Manual. Section: B1.5.5 Reset behavior.
 */

/*
 *	The folowing externally linked variables represent addresses in memory.
 */
extern uint32_t __data_dest_start__;
extern uint32_t __data_dest_end__;
extern uint32_t __data_src__;

extern uint32_t __bss_start__;
extern uint32_t __bss_end__;

extern uint32_t __vectors_start__;

using InitFunction = std::add_pointer<void()>::type;
extern InitFunction __preinit_array_start__;
extern InitFunction __preinit_array_end__;
extern InitFunction __init_array_start__;
extern InitFunction __init_array_end__;

//extern void _init(void);

extern int main();

namespace
{
void table_call(InitFunction* start, InitFunction* end)
{
	std::for_each(start, end, [](const InitFunction f) { f(); });
}
} // namespace

void __prepare_environment()
{
	SCB->CPACR |= (0xF < 20);
	// note: lazy stacking is enabled by default (CPU reset code)

	{
		uint32_t* dest = &__data_dest_start__;
		uint32_t* src = &__data_src__;
		const uint32_t* end = &__data_dest_end__;
		while (dest < end)
			*(dest++) = *(src++);
	}

	{
		uint32_t* dest = &__bss_start__;
		const uint32_t* end = &__bss_end__;
		while (dest < end)
			*(dest++) = 0;
	}

	// SCB->VTOR = __vectors_start__;

	// todo: clear stack/heap
	// todo: invalidate caches

//	_init();

	table_call(&__preinit_array_start__, &__preinit_array_end__);
	table_call(&__init_array_start__, &__init_array_end__);
}

 void __start()
{
	main();

	// todo: hit the debugger? restart?
	while (true) {}
}