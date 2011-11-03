funcdef float INTERPOLATION_FILTER(const float v);

float defaultFilter(const float v) { return v; }
float smoothEnd(const float v) { return sin(v * (PI/2)); }

vector2 interpolate(const vector2 &in a, const vector2 &in b, const float bias)
{
	return a + ((b - a) * bias);
}

vector3 interpolate(const vector3 &in a, const vector3 &in b, const float bias)
{
	return a + ((b - a) * bias);
}

class InterpolationTimer
{
	InterpolationTimer(const uint _millisecs, const bool dontPause)
	{
		reset(_millisecs);
		@m_filter = @smoothEnd;
		m_dontPause = dontPause;
	}
	
	void update()
	{
		if (m_dontPause)
			m_elapsedTime += GetLastFrameElapsedTime();
		else
			m_elapsedTime += g_timeManager.getLastFrameElapsedTime();
	}

	float getBias() const
	{
		return (!isOver()) ? m_filter(min(max(float(m_elapsedTime) / float(m_time), 0.0f), 1.0f)) : 1.0f;
	}

	void reset(const uint _millisecs)
	{
		m_time = _millisecs;
		m_elapsedTime = 0;
	}

	bool isOver() const
	{
		return (m_elapsedTime > m_time);
	}

	uint m_elapsedTime;
	uint m_time;
	INTERPOLATION_FILTER@ m_filter;
	bool m_dontPause;
}

class PositionInterpolator : InterpolationTimer
{
	private vector2 m_a;
	private vector2 m_b;

	PositionInterpolator(const vector2 &in _a, const vector2 &in _b, const uint _millisecs, const bool dontPause = false)
	{
		super(_millisecs, dontPause);
		reset(_a, _b, _millisecs);
	}

	void reset(const vector2 &in _a, const vector2 &in _b, const uint _millisecs)
	{
		InterpolationTimer::reset(_millisecs);
		m_a = _a;
		m_b = _b;
	}

	vector2 getCurrentPos() const
	{
		if (m_elapsedTime > m_time)
		{
			return m_b;
		}
		else
		{
			const float bias = getBias();
			return interpolate(m_a, m_b, bias);
		}
	}
}
