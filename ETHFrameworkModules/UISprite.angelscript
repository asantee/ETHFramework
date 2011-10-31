class UISprite
{
	private string m_spriteName;
	private uint m_color;
	private vector2 m_origin;
	private vector2 m_pos;
	private vector2 m_size;
	private PositionInterpolator m_interp;
	private uint m_a;
	private uint m_r;
	private uint m_g;
	private uint m_b;

	UISprite(const string &in _spriteName, const uint _color, const vector2 &in _pos, const vector2 &in _origin)
	{
		m_pos = _pos;
		m_origin = _origin;
		m_color = _color;
		m_spriteName = _spriteName;
		init();
		m_size = g_scale.scale(GetSpriteSize(m_spriteName));
	}

	UISprite(const string &in _spriteName, const uint _color, const vector2 &in _pos, const vector2 &in _size, const vector2 &in _origin)
	{
		m_pos = _pos;
		m_origin = _origin;
		m_color = _color;
		m_spriteName = _spriteName;
		init();
		m_size = _size;
	}
	
	private void init()
	{
		LoadSprite(m_spriteName);
		m_interp = PositionInterpolator(m_pos, m_pos, 1000);
		m_a = (0xFF000000 & m_color) >> 24;
		m_r = (0x00FF0000 & m_color) >> 16;
		m_g = (0x0000FF00 & m_color) >> 8;
		m_b = (0x000000FF & m_color);
		m_color = ARGB(0, m_r, m_g, m_b);
	}

	void update()
	{
		if (!m_interp.isOver())
			m_interp.update();
		const float alpha = m_interp.getBias() * float(m_a);
		m_color = ARGB(uint(alpha), m_r, m_g, m_b);
	}

	void draw()
	{
		drawSprite(m_spriteName, m_pos, m_origin, m_size, m_color);
	}
}