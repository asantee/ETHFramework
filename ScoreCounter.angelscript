class ScoreCounter : Timer
{
	private int m_start;
	private int m_end;
	private uint m_stride;
	private int m_current;

	ScoreCounter(const int start, const int end, const uint stride)
	{
		super(false);
		m_start = start;
		m_end = end;
		m_stride = stride;
		m_current = start;
	}

	int getCurrent() const
	{
		return m_current;
	}

	int getEnd() const
	{
		return m_end;
	}

	float getBias() const
	{
		const float diff = float(m_end - m_start);
		const float timeBias = (float(getTime()) / float(m_stride)) / abs(diff);
		return (float(m_current - m_start) / diff);
	}

	void update()
	{
		Timer::update();
		if (getTime() >= m_stride && m_current != m_end)
		{
			Timer::reset();
			if (m_current < m_end)
				m_current++;
			else if (m_current > m_end)
				m_current--;
		}
	}
}
