class FrameTimer
{
	FrameTimer()
	{
		m_currentFrame = m_currentFirst = m_currentLast = 0;
		m_lastTime = 0;
	}

	uint get() const
	{
		return m_currentFrame;
	}
	
	void setCurrentFrame(const uint currentFrame)
	{
		m_currentFrame = currentFrame;
		m_lastTime = GetTime();
	}
	
	void reset()
	{
		m_currentStride = 0;
		m_currentFrame = m_currentFirst;
	}

	uint set(const uint first, const uint last, const uint stride, const bool repeat = true)
	{
		if (first != m_currentFirst || last != m_currentLast)
		{
			m_currentFrame = first;
			m_currentFirst = first;
			m_currentLast  = last;
			m_lastTime = GetTime();
			return m_currentFrame;
		}

		if (GetTime()-m_lastTime > stride)
		{
			m_currentFrame++;
			if (m_currentFrame > last)
			{
				if (repeat)
				{
					m_currentFrame = first;
				}
				else
				{
					m_currentFrame = last;
				}
			}
			m_lastTime = GetTime();
		}

		m_currentStride = stride;
		return m_currentFrame;
	}

	bool isLastFrame() const
	{
		return m_currentFrame == m_currentLast;
	}

	float getBias() const
	{
		return (float(min(GetTime()-m_lastTime, m_currentStride)) / max(1.0f, float(m_currentStride)));
	}

	private uint m_currentStride;
	private uint m_lastTime;
	private uint m_currentFirst;
	private uint m_currentLast;
	private uint m_currentFrame;
}
