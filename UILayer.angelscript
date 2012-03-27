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

	void addGlobalSoundSwitch(const string &in name, const string &in on, const string &in off,
							  const vector2 &in normPos, const vector2 &in origin, const float superScale = 1.0f)
	{
		const vector2 spriteSize(GetSpriteSize(on));
		const float currentScale = g_scale.getScale() * superScale;
		const vector2 unPos(unnormalizePos(normPos));
		m_buttons.insertLast(GlobalSoundSwitch(on, off, unPos, currentScale, origin));
		m_buttons[m_buttons.length() - 1].setName(name);
	}

	void addGlobalMusicSwitch(const string &in name, const string &in on, const string &in off,
							  const vector2 &in normPos, const vector2 &in origin, const float superScale = 1.0f)
	{
		const vector2 spriteSize(GetSpriteSize(on));
		const float currentScale = g_scale.getScale() * superScale;
		const vector2 unPos(unnormalizePos(normPos));
		m_buttons.insertLast(GlobalMusicSwitch(on, off, unPos, currentScale, origin));
		m_buttons[m_buttons.length() - 1].setName(name);
	}

	void addSwitch(const string &in name, const string &in on, const string &in off, const vector2 &in normPos, const vector2 &in origin, const float superScale)
	{
		const vector2 spriteSize(GetSpriteSize(on));
		const float currentScale = g_scale.getScale() * superScale;
		const vector2 unPos(unnormalizePos(normPos));
		m_buttons.insertLast(UISwitch(on, off, unPos, currentScale, origin));
		m_buttons[m_buttons.length() - 1].setName(name);
	}

	void addSwitch(const string &in name, const string &in on, const string &in off, const vector2 &in normPos, const vector2 &in origin)
	{
		addSwitch(name, on, off, normPos, origin, 1.0f);
	}

	void addSwitch(const string &in name, const string &in on, const string &in off, const vector2 &in normPos)
	{
		addSwitch(name, on, off, normPos, V2_HALF);
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
	
	void setButtonsSound(const string &in filePath)
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			m_buttons[t].setSound(filePath);
		}
	}

	UISprite@ getSprite(const string &in name)
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			if (m_sprites[t].getName() == name)
			{
				return @(m_sprites[t]);
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

	bool getSwitchState(const string &in name) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				UISwitch@ s = cast<UISwitch>(m_buttons[t]);
				if (s !is null)
				{
					return s.isSwitched();
				}
				else
				{
					print("\x07" + name + " is not a switch");
					return false;
				}
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

	void setButtonOffset(const string &in name, const vector2 &in pos) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				m_buttons[t].setOffset(pos);
				return;
			}
		}
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

	bool buttonExist(const string &in name) const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				return true;
			}
		}
		return false;
	}

	bool removeButton(const string &in name)
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == name)
			{
				m_buttons.removeAt(t);
				return true;
			}
		}
		return false;
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
		removeDismissedButtons();
		removeDismissedSprites();
	}

	void draw()
	{
		if (isHidden())
			return;

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

	void dismissSprite(const string &in spriteName)
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			if (m_sprites[t].getName() == spriteName)
			{
				m_sprites[t].dismiss();
				break;
			}
		}
	}

	bool isEverythingDismissed() const
	{
		return (areAllSpritesDismissed() && areAllButtonsDismissed());
	}

	void dismissButton(const string &in buttonName)
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].getName() == buttonName)
			{
				m_buttons[t].dismiss();
				break;
			}
		}
	}
	
	bool areAllButtonsDismissed() const
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (!m_buttons[t].isDismissed() || !m_buttons[t].isAnimationFinished())
			{
				return false;
			}
		}
		return true;
	}

	bool areAllSpritesDismissed() const
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			if (!m_sprites[t].isDismissed() || !m_sprites[t].isAnimationFinished())
			{
				return false;
			}
		}
		return true;
	}

	void dismiss()
	{
		dismissSprites();
		dismissButtons();
	}

	void dismissSprites()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			if (!m_sprites[t].isDismissed())
			{
				m_sprites[t].dismiss();
			}
		}
	}

	void dismissButtons()
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (!m_buttons[t].isDismissed())
			{
				m_buttons[t].dismiss();
			}
		}
	}

	private void removeDismissedButtons()
	{
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (m_buttons[t].isDismissed() && m_buttons[t].isAnimationFinished())
			{
				m_buttons.removeAt(t--);
			}
		}
	}

	private void removeDismissedSprites()
	{
		for (uint t = 0; t < m_sprites.length(); t++)
		{
			if (m_sprites[t].isDismissed() && m_sprites[t].isAnimationFinished())
			{
				m_sprites.removeAt(t--);
			}
		}
	}
}
