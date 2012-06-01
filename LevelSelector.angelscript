class LevelSelector : ItemSelector
{
	private bool m_startOnFirstPage;

	LevelSelector(const string &in sceneName, PageProperties@ props, const bool startOnFirstPage = true)
	{
		m_startOnFirstPage = startOnFirstPage;
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
		int r = int(props.numItems) - 1;
		for (uint t = 0; t < props.numItems; t++)
		{
			if (!props.itemChooser.validateItem(t))
			{
				r = int(t) - 1;
				break;
			}
		}
		r = max(r, 0);
		return r;
	}

	void preLoop()
	{
		ItemSelector::preLoop();

		if (!m_startOnFirstPage)
			m_pageManager.setCurrentPage(m_pageManager.pageOf(findLastUnlockedLevel(@m_props)));

		enableActivatedButtonBounceEffect();
	}

	void enableActivatedButtonBounceEffect()
	{
		const int lastUnlockedLevel = findLastUnlockedLevel(@m_props);
		const int pageCount = int(m_pageManager.getPageCount());
		const int buttonsPerPage = int(m_pageManager.getNumButtonsPerPage());
		if (lastUnlockedLevel >= 0 && lastUnlockedLevel < pageCount * buttonsPerPage)
		{
			const uint currentPage = lastUnlockedLevel / uint(buttonsPerPage);
			const uint relativeButtonIdx = uint(int((lastUnlockedLevel % buttonsPerPage)));
			Button@ lastUnlockedLevelButton = m_pageManager.getButton(currentPage, relativeButtonIdx);
			//print(currentPage + ", " + relativeButtonIdx + ", " + m_pageManager.getNumButtonsPerPage());

			if (lastUnlockedLevelButton !is null)
			{
				lastUnlockedLevelButton.setBounce(
					m_props.highlightButtonBounceMin,
					m_props.highlightButtonBounceMax,
					m_props.highlightButtonBounceTimeStride);
			}
		}
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
