class LevelSelector : ItemSelector
{
	LevelSelector(const string &in sceneName, PageProperties@ props)
	{
		super(sceneName, @props);
	}

	void loop()
	{
		ItemSelector::loop();
	}

	string getName()
	{
		return "LevelSelector";
	}
}

bool levelChooser(const uint levelIdx)
{
	g_stateManager.setState(g_gameStateFactory.createGameState(levelIdx));
	return true;
}
