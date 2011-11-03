class sTimeManager
{
	private float m_factor;

	sTimeManager()
	{
		m_factor = 1.0f;
	}
	
	bool isPaused() const
	{
		return (m_factor == 0.0f);
	}

	void pause()
	{
		setFactor(0.0f);
	}

	void resume()
	{
		setFactor(1.0f);
	}

	float getFactor() const
	{
		return m_factor;
	}

	uint getLastFrameElapsedTime()
	{
		return uint(float(GetLastFrameElapsedTime()) * m_factor);
	}

	void setFactor(float _factor)
	{
		m_factor = _factor;
		SetTimeStepScale(m_factor);
	}

	float unitsPerSecond(const float speed)
	{
		return float(double(speed) * double(min(GetLastFrameElapsedTime(), 200)) / 1000.0) * m_factor;
	}

	vector2 unitsPerSecond(const vector2 dir)
	{
		return vector2(unitsPerSecond(dir.x), unitsPerSecond(dir.y));
	}

	float scaledUnitsPerSecond(const float speed)
	{
		return unitsPerSecond(speed) * g_scale.getScale();
	}

	vector2 scaledUnitsPerSecond(const vector2 speed)
	{		
		return vector2(scaledUnitsPerSecond(speed.x), scaledUnitsPerSecond(speed.y));
	}
}

sTimeManager g_timeManager;
