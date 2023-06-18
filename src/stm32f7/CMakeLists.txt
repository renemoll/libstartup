
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#

add_library(stm32_f7 OBJECT
	vector_table.cpp
)
target_link_libraries(stm32_f7
	PRIVATE
		bob_interface
)
