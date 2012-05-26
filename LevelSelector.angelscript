class LevelSelector : ItemSelector
{
	LevelSelector(const string &in sceneName, PageProperties@ props)
	{
		super(sceneName, @props);
	}

	int findFirstUnlockedLevel(PageProperties@ props)
	{
		for (uint t = 0; t < props.numItems; t++)
		{
			if (!props.itemChooser.validateItem(t))
				return t;
		}
		return props.numItems - 1;
	}

	int findLastUnlockedLevel(PageProperties@ props)
	{
		int r = props.numItems - 1;
		for (uint t = 0; t < props.numItems; t++)
		{
			if (!props.itemChooser.validateItem(t))
			{
				r = int(t) - 1;
				break;
			}
		}
		return max(r, 0);
	}

	void preLoop()
	{
		ItemSelector::preLoop();
		m_pageManager.setCurrentPage(m_pageManager.pageOf(findLastUnlockedLevel(@m_props)));
	}

	void loop()
	{
		ItemSelector::loop();
		if (GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
		{
			g_stateManager.setState(g_gameStateFactory.createMenuState());
		}
	}

	string getName()
	{
		return "LevelSelector";
	}
}
