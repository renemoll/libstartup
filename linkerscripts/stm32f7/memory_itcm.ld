MEMORY
{
	/*
	 * On the STM32F767, there is a single FLASH region mapped on two
	 * interfaces: AXI and ITCM. Each mapping has an unique memory region:
	 */

	/* FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 2M */
	FLASH (rx)  : ORIGIN = 0x00200000, LENGTH = 2M

	/*
	 * Tightly Coupled Memories
	 */
	
	ITCMRAM (rwx) : ORIGIN = 0x00000000, LENGTH = 16K
	DTCMRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 128K

	/*
	 * SRAM is defined in two blocks: SRAM1 and SRAM2. The regions are continous
	 * and have the same characteristics, hence I map it as a single region.
	*/
	/* SRAM1 (xrw) : ORIGIN = 0x20020000, LENGTH = 368K */
	/* SRAM2 (xrw) : ORIGIN = 0x2007C000, LENGTH = 16K */

	SRAM    (rwx) : ORIGIN = 0x20020000, LENGTH = 384K
	BKPSRAM (rw)  : ORIGIN = 0x40024000, LENGTH = 4K
}