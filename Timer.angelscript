class Timer : GameController
{
	private uint m_time;
	private bool m_pausable;

	Timer()
	{
		m_pausable = true;
		reset();
	}

	Timer(bool pausable)
	{
		m_pausable = pausable;
		reset();
	}

	void update()
	{
		if (m_pausable)
			m_time += g_timeManager.getLastFrameElapsedTime();
		else
			m_time += GetLastFrameElapsedTime();
	}

	void reset()
	{
		m_time = 0;
	}

	void draw() {}

	uint getTime() const
	{
		return m_time;
	}
}
