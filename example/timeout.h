#ifndef TIMEOUT_H
#define TIMEOUT_H

#include <atomic>

class Timeout {
public:
	Timeout(unsigned int value);

	void increment();
	[[nodiscard]] bool triggered();

private:
	const unsigned int m_timeout;
	unsigned int m_count = 0;
	std::atomic_bool m_triggered = false;
};

extern Timeout g_timer;

#endif
