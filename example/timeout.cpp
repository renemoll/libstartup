
#include "timeout.h"

Timeout::Timeout(value_type value)
	: m_timeout{value}
{
}

void Timeout::increment()
{
	++m_count;

	if (m_count > m_timeout){
		m_count = 0;
		m_triggered = true;
	}
}

bool Timeout::triggered()
{
	if (!m_triggered)
		return false;
	
	m_triggered = false;
	return true; 
}

Timeout g_timer{25000};
