class UIButton : Button, UIElement
{
	private vector2 m_destPos;
	private PositionInterpolator m_interp;
	private vector2 m_initPos;
	private bool m_dismissed;
	private vector2 m_offset;

	UIButton(const string _name, const vector2 &in _pos, const float _buttonScale,
			 const vector2 &in _origin = vector2(0.5f, 0.5f), const float effectScale = 1.0f)
	{
		const vector2 _initPos = _pos + (normalize(_pos - (GetScreenSize() * 0.5f)) * g_scale.scale(32)) * effectScale;
		super(_name, _initPos, _buttonScale, _origin);
		m_initPos = _initPos;
		m_destPos = _pos;
		m_interp = PositionInterpolator(_initPos, _pos, 700, true);
		setColor(0.0f);
		m_dismissed = false;
		m_offset = V2_ZERO;
	}

	void reset()
	{
		m_interp.reset(m_initPos, m_destPos, 700);
	}

	void update()
	{
		if (!isAnimationFinished())
			m_interp.update();
		m_pos = m_interp.getCurrentPos();
		
		float alpha;
		if (!m_dismissed)
		{
			Button::update();
			alpha = m_interp.getUnfilteredBias();
		}
		else
		{
			alpha = 1.0f - m_interp.getBias();
		}
		setColor(alpha);
	}
	
	void setOffset(const vector2 &in offset)
	{
		m_offset = offset;
	}

	void dismiss()
	{
		if (!m_dismissed)
		{
			m_dismissed = true;
			m_interp.reset(m_destPos, m_initPos, 700);
		}
	}

	bool isDismissed() const
	{
		return m_dismissed;
	}

	void draw()
	{
		Button::draw(m_offset);
	}

	private void setColor(const float alpha)
	{
		const uint r = (0x00FF0000 & m_color) >> 16;
		const uint g = (0x0000FF00 & m_color) >> 8;
		const uint b = (0x000000FF & m_color);
		m_color = ARGB(uint(alpha * 255.0f), r, g, b);
	}

	bool isAnimationFinished() const
	{
		return m_interp.isOver();
	}
}
