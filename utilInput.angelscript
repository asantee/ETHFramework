class TouchGapDetector
{
	private vector2[] m_touchHitPos;
	private float[] m_touchGap;
	private float[] m_maxTouchGap;
	private uint m_maxTouchCount;

	TouchGapDetector()
	{
		ETHInput@ input = GetInputHandle();
		m_maxTouchCount = input.GetMaxTouchCount();
		m_touchHitPos.resize(m_maxTouchCount);
		m_touchGap.resize(m_maxTouchCount);
		m_maxTouchGap.resize(m_maxTouchCount);
	}

	void update()
	{
		ETHInput@ input = GetInputHandle();
		for (uint t = 0; t < m_maxTouchCount; t++)
		{
			if (input.GetTouchState(t) == KS_HIT)
			{
				m_touchHitPos[t] = input.GetTouchPos(t);
				m_maxTouchGap[t] = 0;
			}
			else if (input.GetTouchState(t) == KS_DOWN)
			{
				m_touchGap[t] = distance(m_touchHitPos[t], input.GetTouchPos(t));
				m_maxTouchGap[t] = max(m_touchGap[t], m_maxTouchGap[t]);
			}
		}
	}

	float getLastTouchGap(const uint t) const
	{
		return m_touchGap[t];
	}

	float getLastMaxTouchGap(const uint t) const
	{
		return m_maxTouchGap[t];
	}
}
