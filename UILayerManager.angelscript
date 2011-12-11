class UILayerManager : GameController
{
	private UILayer@[] m_layers;
	private int m_currentLayer;

	UILayerManager()
	{
		m_currentLayer =-1;
	}

	void addLayer(UILayer@ layer)
	{
		UILayer@ layerSeek = getLayer(layer.getName());
		if (layerSeek !is null)
		{
			for (uint t = 0; t < m_layers.length(); t++)
			{
				if (m_layers[t].getName() == layer.getName())
				{
					@(m_layers[t]) = @layer;
				}
			}
		}
		else
		{
			m_layers.insertLast(layer);
		}
	}

	void openPopup(Popup@ popup)
	{
		addLayer(@popup);
		setCurrentLayer(popup.getName());
	}

	void update()
	{
		updateAlwaysActiveLayers();
		if (m_currentLayer >= 0)
			m_layers[m_currentLayer].update();
		removeDismissedLayers();
	}

	void draw()
	{		
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (!m_layers[t].isHidden() && m_currentLayer != t)
				m_layers[t].draw();
		}
		if (m_currentLayer >= 0)
			m_layers[m_currentLayer].draw();
	}

	private void updateAlwaysActiveLayers()
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].isAlwaysActive() && !isCurrentLayer(t))
			{
				m_layers[t].update();
			}
		}
	}

	bool setCurrentLayer(const string &in name)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].getName() == name)
			{
				m_currentLayer = t;
				m_layers[t].hide(false);
				return true;
			}
		}
		return false;
	}

	bool removeLayer(const string &in name)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].getName() == name)
			{
				m_layers.removeAt(t);
				return true;
			}
		}
		return false;
	}

	void dismissLayer(const string &in name)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].getName() == name)
			{
				if (!m_layers[t].isEverythingDismissed())
					m_layers[t].dismiss();
				return;
			}
		}
	}

	bool setLayerVisible(const string &in name, const bool visible)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].getName() == name)
			{
				m_layers[t].hide(!visible);
				return true;
			}
		}
		return false;
	}

	
	bool setButtonsSound(const string &in filePath)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			m_layers[t].setButtonsSound(filePath);
		}
		return false;
	}

	bool isPointInButton(const vector2 &in p) const
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (!m_layers[t].isHidden())
			{
				if (m_layers[t].isPointInButton(p))
				{
					return true;
				}
			}
		}
		return false;
	}

	UILayer@ getLayer(const string &in name)
	{
		const int size = m_layers.length();
		for (int t = 0; t < size; t++)
		{
			if (m_layers[t].getName() == name)
			{
				return m_layers[t];
			}
		}
		return null;
	}
	
	private bool isCurrentLayer(const int idx)
	{
		return (m_currentLayer == idx);
	}

	UILayer@ getCurrentLayer()
	{
		if (m_currentLayer >= 0)
			return @(m_layers[m_currentLayer]);
		else
			return null;
	}

	bool isButtonPressed(const string &in name) const
	{
		if (m_currentLayer != -1)
			return m_layers[m_currentLayer].isButtonPressed(name);
		else
			return false;
	}

	bool buttonExist(const string &in name) const
	{
		if (m_currentLayer != -1)
			return m_layers[m_currentLayer].buttonExist(name);
		else
			return false;
	}

	void setButtonPressed(const string &in name, const bool pressed) const
	{
		if (m_currentLayer != -1)
			m_layers[m_currentLayer].setButtonPressed(name, pressed);
	}

	private void removeDismissedLayers()
	{
		for (int t = 0; t < int(m_layers.length()); t++)
		{
			if (m_layers[t].isEverythingDismissed() && t != m_currentLayer)
			{
				m_layers.removeAt(t--);
			}
		}
	}
}
