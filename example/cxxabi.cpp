
#include <cassert>

extern "C"
{
void *__dso_handle = &__dso_handle;

void __cxa_pure_virtual()
{
	assert("virt.pure");
}

void __cxa_deleted_virtual()
{
	assert("virt.del");
}
}

#include <atomic>

enum
{
	UNINITIALIZED = 0,
	INITIALIZED = 1,
	INITIALIZING = 0x100,
};

// This function returns 1 only if the object needs to be initialized
extern "C" int __cxa_guard_acquire(int *guard)
{
	auto atomic_guard = std::atomic_ref(*guard);
	if (atomic_guard.load() == INITIALIZED)
		return 0;

	if (atomic_guard.exchange(INITIALIZING) == INITIALIZING)
	{
		assert("stat.rec");
	}
	return 1;
}

// After this function the compiler expects `(guard & 1) == 1`!
extern "C" void __cxa_guard_release(int *guard) noexcept
{
	auto atomic_guard = std::atomic_ref(*guard);
	atomic_guard.store(INITIALIZED);
}

// Called if the initialization terminates by throwing an exception.
// After this function the compiler expects `(guard & 3) == 0`!
extern "C" void __cxa_guard_abort([[maybe_unused]] int *guard) noexcept
{
}
