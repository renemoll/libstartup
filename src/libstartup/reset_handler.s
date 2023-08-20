.syntax unified

.global ResetHandler
.section .text.ResetHandler
	.align 4
	.func ResetHandler
	.type ResetHandler, %function
ResetHandler:
	ldr sp, =__stack_top__
	bl CycleCounterStart
	bl __prepare_environment
	b __start
	.endfunc
	.size ResetHandler, .-ResetHandler
