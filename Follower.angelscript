class Follower : GameController
{
	private uint m_interpStride;
	private uint m_updateRate;
	private vector2 m_destPos;
	private PositionInterpolator@ m_interp;
	private uint m_switchTime;

	Follower(const vector2 &in pos, const uint interpStride = 600, const uint updateRate = 100)
	{
		m_interpStride = interpStride;
		m_updateRate = updateRate;

		@m_interp = PositionInterpolator(pos, pos, m_interpStride, true);
		@(m_interp.m_filter) = @smoothEnd;
		m_switchTime = 0;
	}

	void setDestinationPos(const vector2 &in destPos)
	{
		m_destPos = destPos;
	}

	void forcePosition(const vector2 &in pos)
	{
		m_interp.forcePointA(pos);
		m_interp.forcePointB(pos);
	}

	vector2 getPos() const
	{
		return m_interp.getCurrentPos();
	}

	void reset(const vector2 &in pos)
	{
		m_interp.reset(pos, m_destPos, m_interpStride);
	}

	void draw() { }
	void update()
	{
		if (m_interp.getCurrentPos() != m_destPos && m_switchTime > m_updateRate)
		{
			reset(m_interp.getCurrentPos());
			m_switchTime = 0;
		}
		m_switchTime += GetLastFrameElapsedTime();
		m_interp.update();
	}
}
