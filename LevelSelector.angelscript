class LevelSelector : ItemSelector
{
	LevelSelector(const string &in sceneName, PageProperties@ props)
	{
		super(sceneName, @props);
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
