.syntax unified

.global Reset_Handler
.section .text.Reset_Handler
	.align 4
	.func Reset_Handler
	.type Reset_Handler, %function
Reset_Handler:
	bl __prepare_environment
	b __start
	.endfunc
	.size Reset_Handler, .-Reset_Handler
