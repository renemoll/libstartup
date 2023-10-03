#ifndef TIMEOUT_H
#define TIMEOUT_H

#include <atomic>

class Timeout {
public:
	using value_type = unsigned int;

	Timeout(value_type value);

	void increment();
	[[nodiscard]] bool triggered();

private:
	const value_type m_timeout;
	// std::atomic<value_type> m_count = 0;
	value_type m_count = 0;
	// std::atomic_bool m_triggered = false;
	bool m_triggered = false;
};

extern Timeout g_timer;

#endif
