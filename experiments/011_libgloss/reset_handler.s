.syntax unified

.global ResetHandler
.section .text.ResetHandler
	.align 4
	.func ResetHandler
	.type ResetHandler, %function
ResetHandler:
	b _mainCRTStartup
	.endfunc
	.size ResetHandler, .-ResetHandler
