class ItemSelector : BaseState
{
	PageProperties@ m_props;
	PageManager@ m_pageManager;
	string m_sceneName;

	ItemSelector(const string &in sceneName, PageProperties@ props)
	{
		@m_props = @props;
		m_sceneName = sceneName;
	}

	void start()
	{
		BaseState::start();
		loadScene(m_sceneName);
	}

	void preLoop()
	{
		BaseState::preLoop();
		@m_pageManager = PageManager(@m_props);

		m_layerManager.addLayer(@m_pageManager);
		m_layerManager.setCurrentLayer("PageManager");
	}

	string getName()
	{
		return "ItemSelector";
	}
}
