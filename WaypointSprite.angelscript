class WaypointSprite : WaypointManager
{
	private string m_spriteName;
	private float m_scale;
	private vector2 m_origin;

	WaypointSprite(const string &in spriteName, const vector2 &in origin, const float scale, const bool repeat)
	{
		super(repeat);
		m_spriteName = spriteName;
		m_origin = origin;
		m_scale = scale;
		LoadSprite(spriteName);
	}

	void draw()
	{
		Waypoint wp = getCurrentPoint();
		drawSprite(m_spriteName, wp.pos, m_origin, GetSpriteFrameSize(m_spriteName) * m_scale, wp.color.getUInt(), 0.0f);
	}
}
