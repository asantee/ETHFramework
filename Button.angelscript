﻿class Button
{
	private string m_spriteName;
	private vector2 m_pos;
	private vector2 m_origin;
	private vector2 m_size;
	private uint m_color;
	private uint m_customColor;
	private bool m_pressed;
	private bool m_lastTouchInButton;
	private vector2 m_lastDownPos;
	private float m_buttonScale;
	private string m_name;
	private string m_buttonSound;
	private uint m_elapsedTime;

	private vector2 m_currentBounceScale;
	private vector2 m_bounceScaleA;
	private vector2 m_bounceScaleB;
	private uint m_bounceStride;

	private vector3 m_currentBlinkColor;
	private vector3 m_blinkColorA;
	private vector3 m_blinkColorB;
	private uint m_blinkStride;

	Button(const string _spriteName, const vector2 &in _pos, const float _buttonScale, const vector2 &in _origin = vector2(0, 0))
	{
		m_origin = _origin;
		m_spriteName = _spriteName;
		m_buttonScale = _buttonScale;
		m_pos = _pos;
		LoadSprite(m_spriteName);
		m_size = GetSpriteSize(m_spriteName) * m_buttonScale;
		m_color = 0xFFFFFFFF;
		m_pressed = false;
		m_lastTouchInButton = false;
		m_customColor = COLOR_WHITE;
		m_elapsedTime = 0;
		setBounce(V2_ONE, V2_ONE, 300);
		setBlink(V3_ONE, V3_ONE, 300);
	}

	void setSound(const string &in buttonSound)
	{
		m_buttonSound = buttonSound;
		if (m_buttonSound != "")
			LoadSoundEffect(m_buttonSound);
	}

	void setName(const string &in _name)
	{
		m_name = _name;
	}

	string getName() const
	{
		return m_name;
	}

	vector2 getPos()
	{
		return m_pos;
	}
	
	void setPos(const vector2 _pos)
	{
		m_pos = _pos;
	}

	void setCustomColor(const uint customColor)
	{
		m_customColor = customColor;
	}

	uint getCustomColor() const
	{
		return m_customColor;
	}

	void setScale(const float scale)
	{
		m_buttonScale = scale;
		m_size = GetSpriteSize(m_spriteName) * m_buttonScale;
	}

	uint getColor() const
	{
		return m_color;
	}
	
	void setColor(const uint color)
	{
		m_color = color;
	}

	void setButtonBitmap(const string &in _spriteName)
	{
		m_spriteName = _spriteName;
	}
	
	string getButtonBitmap()
	{
		return m_spriteName;
	}
	
	void putButton()
	{
		putButton(vector2(0,0));
	}
	
	void putButton(const vector2 &in offset)
	{
		update();
		draw(offset);
	}

	void draw()
	{
		draw(vector2(0,0));
	}

	bool isInScreen(const vector2 &in offset)
	{
		const vector2 minP = m_pos + offset;
		const vector2 maxP = m_pos + m_size + offset;
		const vector2 screenSize(GetScreenSize());
		if (maxP.x < 0.0f || maxP.y < 0.0f || minP.x > screenSize.x || minP.y > screenSize.y)
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	void draw(const vector2 &in offset)
	{
		// if is not loaded yet, load again (handle android unexpected texture destruction)
		LoadSprite(m_spriteName);
		FloatColor color = FloatColor(m_color) * FloatColor(m_customColor) * FloatColor(m_currentBlinkColor);
		drawScaledSprite(m_spriteName, m_pos + offset, m_currentBounceScale * m_buttonScale, m_origin, color.getUInt());
	}

	vector2 getSize() const
	{
		return m_size;
	}

	bool isPointInButton(const vector2 &in p) const
	{
		return (isPointInRect(p, m_pos, m_size, m_origin));
	}

	void update()
	{
		m_elapsedTime += GetLastFrameElapsedTime();
		m_color = 0xFFFFFFFF;
		ETHInput@ input = GetInputHandle();
		if (input.GetTouchState(0) == KS_HIT)
		{
			m_lastTouchInButton = true;
			m_lastDownPos = input.GetTouchPos(0);
			if (isPointInButton(input.GetTouchPos(0)))
			{
				m_lastTouchInButton = true;
			}
			else
			{
				m_lastTouchInButton = false;
			}
		}
		else if (input.GetTouchState(0) == KS_RELEASE)
		{		
			if (isPointInButton(m_lastDownPos) && m_lastTouchInButton)
			{
				if (!m_pressed && m_buttonSound != "")
				{
					PlaySample(m_buttonSound);
				}
				m_pressed = true;
			}
			m_lastTouchInButton = false;
		}
		else if (input.GetTouchState(0) == KS_DOWN)
		{
			m_lastDownPos = input.GetTouchPos(0);
		}
		if (m_lastTouchInButton && isPointInButton(input.GetTouchPos(0)))
		{
			m_color = 0xFFCCCCCC;
		}
		bounce();
		blinkColor();
	}

	bool isPressed()
	{
		return m_pressed;
	}

	void setPressed(const bool _pressed)
	{
		m_pressed = _pressed;
	}

	void setBounce(const vector2 &in scaleA, const vector2 &in scaleB, const uint stride = 300)
	{
		m_bounceScaleA = scaleA;
		m_bounceScaleB = scaleB;
		m_bounceStride = stride;
		m_currentBounceScale = m_bounceScaleA;
	}

	private void bounce()
	{
		if (m_bounceScaleA == V2_ONE && m_bounceScaleB == V2_ONE)
		{
			m_currentBounceScale = V2_ONE;
			return;
		}

		const bool invert = (((m_elapsedTime / m_bounceStride) % 2) == 1);
		float bias = float(m_elapsedTime % m_bounceStride) / float(m_bounceStride);
		bias = invert ? 1.0f - bias : bias;
		m_currentBounceScale = interpolate(m_bounceScaleA, m_bounceScaleB, smoothEnd(bias));
	}

	void setBlink(const vector3 &in colorA, const vector3 &in colorB, const uint stride = 300)
	{
		m_currentBlinkColor = colorA;
		m_blinkColorA = colorA;
		m_blinkColorB = colorB;
		m_blinkStride = stride;
	}

	void blinkColor()
	{
		if (m_blinkColorA == V3_ONE && m_blinkColorB == V3_ONE)
		{
			m_currentBlinkColor = V3_ONE;
			return;
		}

		const bool invert = (((m_elapsedTime / m_blinkStride) % 2) == 1);
		float bias = float(m_elapsedTime % m_blinkStride) / float(m_blinkStride);
		bias = invert ? 1.0f - bias : bias;
		m_currentBlinkColor = interpolate(m_blinkColorA, m_blinkColorB, bias);
	}
}
