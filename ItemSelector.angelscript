class ItemSelector : BaseState
{
	PageProperties@ m_props;
	PageManager@ m_pageManager;
	string m_sceneName;
	int m_startPage;

	ItemSelector(const string &in sceneName, PageProperties@ props, const int startPage = 0)
	{
		@m_props = @props;
		m_sceneName = sceneName;
		m_startPage = startPage;
	}

	void start()
	{
		BaseState::start();
		loadScene(m_sceneName);
	}

	void preLoop()
	{
		BaseState::preLoop();
		@m_pageManager = PageManager(@m_props, m_startPage);

		m_layerManager.addLayer(@m_pageManager);
		m_layerManager.setCurrentLayer("PageManager");

		if (m_props.buttonSound != "")
		{
			m_layerManager.setButtonsSound(m_props.buttonSound);
		}
	}

	string getName()
	{
		return "ItemSelector";
	}
}
