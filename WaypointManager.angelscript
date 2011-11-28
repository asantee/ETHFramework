class Waypoint
{
	Waypoint(const vector2 &in _pos, const uint _time, FloatColor _color, INTERPOLATION_FILTER@ _filter = @smoothEnd)
	{
		pos = _pos;
		time = _time;
		@filter = @_filter;
		color = _color;
	}
	vector2 pos;
	FloatColor color;
	uint time;
	INTERPOLATION_FILTER@ filter;
}

class WaypointManager : GameController
{
	private FrameTimer m_timer;
	private Waypoint@[] m_waypoints;
	private bool m_repeat;

	WaypointManager(const bool repeat)
	{
		m_repeat = repeat;
		m_timer.set(0,0,0,repeat);
	}

	void addWaypoint(Waypoint@ waypoint)
	{
		m_waypoints.insertLast(@waypoint);
	}

	void reset()
	{
		m_timer.reset();
	}

	Waypoint getCurrentPoint() const
	{
		const uint currentFrame = m_timer.get();
		uint nextFrame;
		if (m_timer.isLastFrame())
		{
			if (m_repeat)
				nextFrame = 0;
			else
				nextFrame = currentFrame;
		}
		else
		{
			nextFrame = currentFrame + 1;
		}
		
		Waypoint@ current = m_waypoints[currentFrame];
		Waypoint@ next = m_waypoints[nextFrame];
		INTERPOLATION_FILTER@ filter = @(current.filter);
		const float bias = m_timer.getBias();
		return Waypoint
		(
			interpolate(current.pos, next.pos, filter(bias)),
			0,
			interpolate(current.color, next.color, filter(bias)),
			null
		);
	}

	void update()
	{
		m_timer.set(0, m_waypoints.length() - 1, m_waypoints[m_timer.get()].time, m_repeat);
	}

	void draw() { }
}
