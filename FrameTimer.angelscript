class FrameTimer
{
	FrameTimer()
	{
		m_currentFrame = m_currentFirst = m_currentLast = 0;
		m_time = 0;
	}

	uint get() const
	{
		return m_currentFrame;
	}
	
	void setCurrentFrame(const uint currentFrame)
	{
		m_currentFrame = currentFrame;
		m_time = 0;
	}
	
	void reset()
	{
		m_currentStride = 0;
		m_currentFrame = m_currentFirst;
	}

	void setCurrentStride(const uint stride)
	{
		m_currentStride = stride;
	}

	uint set(const uint first, const uint last, const uint stride, const bool repeat = true)
	{
		m_currentStride = stride;
		m_time += GetLastFrameElapsedTime();
		if (first != m_currentFirst || last != m_currentLast)
		{
			m_currentFrame = first;
			m_currentFirst = first;
			m_currentLast  = last;
			m_time = 0;
			return m_currentFrame;
		}

		if (m_time >= stride)
		{
			m_currentFrame++;
			m_time -= stride;

			if (m_currentFrame > last)
			{
				if (repeat)
				{
					m_currentFrame = first;
				}
				else
				{
					m_currentFrame = last;
					m_time = 0;
				}
			}
		}

		return m_currentFrame;
	}

	bool isLastFrame() const
	{
		return m_currentFrame == m_currentLast;
	}

	float getBias() const
	{
		return (float(min(m_time, m_currentStride)) / max(1.0f, float(m_currentStride)));
	}

	uint getCurrentFirstFrame() const
	{
		return m_currentFirst;
	}

	uint getCurrentLastFrame() const
	{
		return m_currentLast;
	}

	private uint m_currentStride;
	private uint m_time;
	private uint m_currentFirst;
	private uint m_currentLast;
	private uint m_currentFrame;
}
