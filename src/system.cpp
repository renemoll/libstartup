
#include "libstartup/system.h"

#include <algorithm>
#include <cinttypes>

extern uint32_t __data_dest_start__;
extern uint32_t __data_dest_end__;
extern uint32_t __data_src__;

extern uint32_t __bss_start__;
extern uint32_t __bss_end__;

using InitFunction = std::add_pointer<void()>::type;

extern InitFunction __preinit_array_start__;
extern InitFunction __preinit_array_end__;
extern InitFunction __init_array_start__;
extern InitFunction __init_array_end__;
extern InitFunction __fini_array_start__;
extern InitFunction __fini_array_end__;

extern int main();

namespace
{
void copy_data_section()
{
	const auto count = (&__data_dest_end__ - &__data_dest_start__);
	std::copy(&__data_src__, &__data_src__ + count, &__data_dest_start__);
}

void zero_bss_section()
{
	std::fill(&__bss_start__, &__bss_end__, 0u);
}

void table_call(InitFunction* start, InitFunction* end)
{
	std::for_each(start, end, [](const InitFunction f) { f(); });
}
} // namespace

void __prepare_environment()
{
	/*
	 * Copy from FLASH to RAM - data section
	 * Fill bss
	 * Call constructors
	 */
	copy_data_section();
	zero_bss_section();

	table_call(&__preinit_array_start__, &__preinit_array_end__);
	table_call(&__init_array_start__, &__init_array_end__);
}

void __start()
{
	main();

	table_call(&__fini_array_start__, &__fini_array_end__);
}