#include <new>
#include <stdlib.h>

void* operator new  (std::size_t size)
{ 
	return malloc(size);
}
