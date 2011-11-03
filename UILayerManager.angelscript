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
		m_layers.insertLast(layer);
	}

	void update()
	{
		updateAlwaysActiveLayers();
		if (m_currentLayer >= 0)
			m_layers[m_currentLayer].update();
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
}
