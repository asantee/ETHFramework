class ItemSelector : BaseState
{
	PageProperties@ m_props;
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

		m_layerManager.addLayer(PageManager(@m_props));
		m_layerManager.setCurrentLayer("PageManager");
	}

	string getName()
	{
		return "ItemSelector";
	}
}
