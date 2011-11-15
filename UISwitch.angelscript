class UISwitch : UIButton
{
	private string m_on;
	private string m_off;
	private bool m_switched;

	UISwitch(const string name, const string off, const vector2 pos, const float buttonScale, const vector2 origin)
	{
		m_on     = name;
		m_off    = off;
		super(m_on, pos, buttonScale, origin);
		m_switched = false;
	}

	bool isEnabled()
	{
		return (getButtonBitmap() == m_on);
	}
	
	bool isSwitched()
	{
		return m_switched;
	}
	
	void setState(bool state)
	{
		if (state)
		{
			setButtonBitmap(m_on);
		}
		else
		{
			setButtonBitmap(m_off);
		}
	}

	void update()
	{
		UIButton::update();
		m_switched = false;
		if (isPressed())
		{
			if (getButtonBitmap() == m_on)
			{
				setButtonBitmap(m_off);
			}
			else
			{
				setButtonBitmap(m_on);
			}
			setPressed(false);
			m_switched = true;
		}
	}
}
