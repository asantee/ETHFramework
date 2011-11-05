class UILayer
{
	private UIButton@[] m_buttons;
	private UISprite@[] m_sprites;
	private bool m_hidden;
	
	UILayer()
	{
		m_hidden = true;
	}

	bool isHidden() const
	{
		return m_hidden;
	}
	
	void hide(const bool hide)
	{
		m_hidden = hide;
		if (m_hidden)
		{
			for (uint t = 0; t < m_buttons.length(); t++)
			{
				m_buttons[t].reset();
			}
			for (uint t = 0; t < m_sprites.length(); t++)
			{
				m_sprites[t].reset();
			}
		}
	}

	void addButton(const string &in name, const string &in spriteName, const vector2 &in normPos, const vector2 &in origin, const float superScale)
	{
		const vector2 spriteSize(GetSpriteSize(spriteName));
		const float currentScale = g_scale.getScale() * superScale;
		const vector2 unPos(unnormalizePos(normPos));
		m_buttons.insertLast(UIButton(spriteName, unPos, currentScale, origin));
		m_buttons[m_buttons.length() - 1].setName(name);
	}

	void addButton(const string &in name, const string &in spriteName, const vector2 &in normPos, const vector2 &in origin)
	{
		addButton(name, spriteName, normPos, origin, 1.0f);
	}

	void addButton(const string &in name, const string &in spriteName, const vector2 &in normPos)
	{
		addButton(name, spriteName, normPos, V2_HALF);
	}

	void addSprite(const string &in spriteName, const uint color, const vector2 &in pos, const vector2 &in origin)
	{
		m_sprites.insertLast(UISprite(spriteName, color, pos, origin));
	}

	void addSprite(const string &in spriteName, const uint color, const vector2 &in pos, const vector2 &in size, const vector2 &in origin)
	{
		m_sprites.insertLast(UISprite(spriteName, color, pos, size, origin));
	}

	UIButton@ getButton(const string &in name)
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				return @(m_buttons[t]);
			}
		}
		return null;
	}

	bool isPointInButton(const vector2 &in p) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].isPointInButton(p))
			{
				return true;
			}
		}
		return false;
	}

	bool isButtonPressed(const string &in name) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				return m_buttons[t].isPressed();
			}
		}
		return false;
	}

	void setButtonPressed(const string &in name, const bool pressed) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				m_buttons[t].setPressed(pressed);
			}
		}
	}

	void update()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			m_sprites[t].update();
		}
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			m_buttons[t].update();
		}
	}

	void draw()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			m_sprites[t].draw();
		}
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			m_buttons[t].draw();
		}
	}

	string getName() const
	{
		return "unnamed";
	}

	bool isAlwaysActive() const
	{
		return false;
	}
}
