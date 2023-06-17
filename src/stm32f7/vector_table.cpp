
#include <cinttypes>
#include <type_traits>

// Ensure the handler function names do not get mangled.
extern "C" {
/*
 * Special handlers:
 * - UndefinedHandler: the default handler.
 * - ResetHandler: called upon MCU reset.
 */
void UndefinedHandler();
void ResetHandler() __attribute__((noreturn));

/*
 * Interrupt handlers:
 * - marked as weak such that they can be overwritten in the user application.
 * - naming is kept intact with the manufacter's naming scheme to avoid confusion.
 */
void NMI_Handler() __attribute__((weak, alias("UndefinedHandler")));
void HardFault_Handler() __attribute__((weak, alias("UndefinedHandler")));
void MemManage_Handler() __attribute__((weak, alias("UndefinedHandler")));
void BusFault_Handler() __attribute__((weak, alias("UndefinedHandler")));
void UsageFault_Handler() __attribute__((weak, alias("UndefinedHandler")));
void SVC_Handler() __attribute__((weak, alias("UndefinedHandler")));
void DebugMon_Handler() __attribute__((weak, alias("UndefinedHandler")));
void PendSV_Handler() __attribute__((weak, alias("UndefinedHandler")));
void SysTick_Handler() __attribute__((weak, alias("UndefinedHandler")));
void WWDG_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void PVD_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TAMP_STAMP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void RTC_WKUP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void FLASH_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void RCC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream6_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void ADC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN1_TX_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN1_RX0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN1_RX1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN1_SCE_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI9_5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM1_BRK_TIM9_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM1_UP_TIM10_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM1_TRG_COM_TIM11_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM1_CC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C1_EV_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C1_ER_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C2_EV_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C2_ER_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void USART1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void USART2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void USART3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void EXTI15_10_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void RTC_Alarm_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_FS_WKUP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM8_BRK_TIM12_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM8_UP_TIM13_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM8_TRG_COM_TIM14_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM8_CC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA1_Stream7_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void FMC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SDMMC1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void UART4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void UART5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM6_DAC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void TIM7_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void ETH_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void ETH_WKUP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN2_TX_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN2_RX0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN2_RX1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN2_SCE_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_FS_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream6_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2_Stream7_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void USART6_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C3_EV_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C3_ER_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_HS_EP1_OUT_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_HS_EP1_IN_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_HS_WKUP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void OTG_HS_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DCMI_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CRYP_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void HASH_RNG_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void RNG_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void FPU_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void UART7_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void UART8_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI4_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI5_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPI6_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SAI1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void LTDC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void LTDC_ER_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DMA2D_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SAI2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void QUADSPI_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void LPTIM1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CEC_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C4_EV_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void I2C4_ER_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SPDIF_RX_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DSI_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DFSDM1_FLT0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DFSDM1_FLT1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DFSDM1_FLT2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void DFSDM1_FLT3_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void SDMMC2_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN3_TX_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN3_RX0_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN3_RX1_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void CAN3_SCE_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void JPEG_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));
void MDIOS_IRQHandler() __attribute__((weak, alias("UndefinedHandler")));

using HandlerFunction = std::add_pointer<void()>::type;
extern uint32_t __vectors_start__;

HandlerFunction vectorTable[] __attribute__((section(".isr_vector"))) = {
	reinterpret_cast<HandlerFunction>(&__vectors_start__),
	ResetHandler,
	NMI_Handler,
	HardFault_Handler,
	MemManage_Handler,
	BusFault_Handler,
	UsageFault_Handler,
	UndefinedHandler,
	UndefinedHandler,
	UndefinedHandler,
	UndefinedHandler,
	SVC_Handler,
	DebugMon_Handler,
	UndefinedHandler,
	PendSV_Handler,
	SysTick_Handler,
	WWDG_IRQHandler,			   // Window WatchDog
	PVD_IRQHandler,				   // PVD through EXTI Line detection
	TAMP_STAMP_IRQHandler,		   // Tamper and TimeStamps through the EXTI line
	RTC_WKUP_IRQHandler,		   // RTC Wakeup through the EXTI line
	FLASH_IRQHandler,			   // FLASH
	RCC_IRQHandler,				   // RCC
	EXTI0_IRQHandler,			   // EXTI Line0
	EXTI1_IRQHandler,			   // EXTI Line1
	EXTI2_IRQHandler,			   // EXTI Line2
	EXTI3_IRQHandler,			   // EXTI Line3
	EXTI4_IRQHandler,			   // EXTI Line4
	DMA1_Stream0_IRQHandler,	   // DMA1 Stream 0
	DMA1_Stream1_IRQHandler,	   // DMA1 Stream 1
	DMA1_Stream2_IRQHandler,	   // DMA1 Stream 2
	DMA1_Stream3_IRQHandler,	   // DMA1 Stream 3
	DMA1_Stream4_IRQHandler,	   // DMA1 Stream 4
	DMA1_Stream5_IRQHandler,	   // DMA1 Stream 5
	DMA1_Stream6_IRQHandler,	   // DMA1 Stream 6
	ADC_IRQHandler,				   // ADC1, ADC2 and ADC3s
	CAN1_TX_IRQHandler,			   // CAN1 TX
	CAN1_RX0_IRQHandler,		   // CAN1 RX0
	CAN1_RX1_IRQHandler,		   // CAN1 RX1
	CAN1_SCE_IRQHandler,		   // CAN1 SCE
	EXTI9_5_IRQHandler,			   // External Line[9:5]s
	TIM1_BRK_TIM9_IRQHandler,	   // TIM1 Break and TIM9
	TIM1_UP_TIM10_IRQHandler,	   // TIM1 Update and TIM10
	TIM1_TRG_COM_TIM11_IRQHandler, // TIM1 Trigger and Commutation and TIM11
	TIM1_CC_IRQHandler,			   // TIM1 Capture Compare
	TIM2_IRQHandler,			   // TIM2
	TIM3_IRQHandler,			   // TIM3
	TIM4_IRQHandler,			   // TIM4
	I2C1_EV_IRQHandler,			   // I2C1 Event
	I2C1_ER_IRQHandler,			   // I2C1 Error
	I2C2_EV_IRQHandler,			   // I2C2 Event
	I2C2_ER_IRQHandler,			   // I2C2 Error
	SPI1_IRQHandler,			   // SPI1
	SPI2_IRQHandler,			   // SPI2
	USART1_IRQHandler,			   // USART1
	USART2_IRQHandler,			   // USART2
	USART3_IRQHandler,			   // USART3
	EXTI15_10_IRQHandler,		   // External Line[15:10]s
	RTC_Alarm_IRQHandler,		   // RTC Alarm (A and B) through EXTI Line
	OTG_FS_WKUP_IRQHandler,		   // USB OTG FS Wakeup through EXTI line
	TIM8_BRK_TIM12_IRQHandler,	   // TIM8 Break and TIM12
	TIM8_UP_TIM13_IRQHandler,	   // TIM8 Update and TIM13
	TIM8_TRG_COM_TIM14_IRQHandler, // TIM8 Trigger and Commutation and TIM14
	TIM8_CC_IRQHandler,			   // TIM8 Capture Compare
	DMA1_Stream7_IRQHandler,	   // DMA1 Stream7
	FMC_IRQHandler,				   // FMC
	SDMMC1_IRQHandler,			   // SDMMC1
	TIM5_IRQHandler,			   // TIM5
	SPI3_IRQHandler,			   // SPI3
	UART4_IRQHandler,			   // UART4
	UART5_IRQHandler,			   // UART5
	TIM6_DAC_IRQHandler,		   // TIM6 and DAC1&2 underrun errors
	TIM7_IRQHandler,			   // TIM7
	DMA2_Stream0_IRQHandler,	   // DMA2 Stream 0
	DMA2_Stream1_IRQHandler,	   // DMA2 Stream 1
	DMA2_Stream2_IRQHandler,	   // DMA2 Stream 2
	DMA2_Stream3_IRQHandler,	   // DMA2 Stream 3
	DMA2_Stream4_IRQHandler,	   // DMA2 Stream 4
	ETH_IRQHandler,				   // Ethernet
	ETH_WKUP_IRQHandler,		   // Ethernet Wakeup through EXTI line
	CAN2_TX_IRQHandler,			   // CAN2 TX
	CAN2_RX0_IRQHandler,		   // CAN2 RX0
	CAN2_RX1_IRQHandler,		   // CAN2 RX1
	CAN2_SCE_IRQHandler,		   // CAN2 SCE
	OTG_FS_IRQHandler,			   // USB OTG FS
	DMA2_Stream5_IRQHandler,	   // DMA2 Stream 5
	DMA2_Stream6_IRQHandler,	   // DMA2 Stream 6
	DMA2_Stream7_IRQHandler,	   // DMA2 Stream 7
	USART6_IRQHandler,			   // USART6
	I2C3_EV_IRQHandler,			   // I2C3 event
	I2C3_ER_IRQHandler,			   // I2C3 error
	OTG_HS_EP1_OUT_IRQHandler,	   // USB OTG HS End Point 1 Out
	OTG_HS_EP1_IN_IRQHandler,	   // USB OTG HS End Point 1 In
	OTG_HS_WKUP_IRQHandler,		   // USB OTG HS Wakeup through EXTI
	OTG_HS_IRQHandler,			   // USB OTG HS
	DCMI_IRQHandler,			   // DCMI
	CRYP_IRQHandler,			   // Crypto
	HASH_RNG_IRQHandler,		   // Hash and Rng
	FPU_IRQHandler,				   // FPU
	UART7_IRQHandler,			   // UART7
	UART8_IRQHandler,			   // UART8
	SPI4_IRQHandler,			   // SPI4
	SPI5_IRQHandler,			   // SPI5
	SPI6_IRQHandler,			   // SPI6
	SAI1_IRQHandler,			   // SAI1
	LTDC_IRQHandler,			   // LTDC
	LTDC_ER_IRQHandler,			   // LTDC error
	DMA2D_IRQHandler,			   // DMA2D
	SAI2_IRQHandler,			   // SAI2
	QUADSPI_IRQHandler,			   // QUADSPI
	LPTIM1_IRQHandler,			   // LPTIM1
	CEC_IRQHandler,				   // HDMI_CEC
	I2C4_EV_IRQHandler,			   // I2C4 Event
	I2C4_ER_IRQHandler,			   // I2C4 Error
	SPDIF_RX_IRQHandler,		   // SPDIF_RX
	DSI_IRQHandler,				   // DSI
	DFSDM1_FLT0_IRQHandler,		   // DFSDM1 Filter 0 global Interrupt
	DFSDM1_FLT1_IRQHandler,		   // DFSDM1 Filter 1 global Interrupt
	DFSDM1_FLT2_IRQHandler,		   // DFSDM1 Filter 2 global Interrupt
	DFSDM1_FLT3_IRQHandler,		   // DFSDM1 Filter 3 global Interrupt
	SDMMC2_IRQHandler,			   // SDMMC2
	CAN3_TX_IRQHandler,			   // CAN3 TX
	CAN3_RX0_IRQHandler,		   // CAN3 RX0
	CAN3_RX1_IRQHandler,		   // CAN3 RX1
	CAN3_SCE_IRQHandler,		   // CAN3 SCE
	JPEG_IRQHandler,			   // JPEG
	MDIOS_IRQHandler,			   // MDIOS
};

void UndefinedHandler()
{
	while (true) {}
}
}