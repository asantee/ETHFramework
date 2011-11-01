class LevelSelector : ItemSelector
{
	LevelSelector(const string &in sceneName, PageProperties@ props)
	{
		super(sceneName, @props);
	}

	string getName()
	{
		return "levelSelector";
	}
}

bool levelChooser(const uint levelIdx)
{
	print("filhadaputa " + levelIdx);
	g_stateManager.setState(g_gameStateFactory.createGameState(levelIdx));
	return true;
}
