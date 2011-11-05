interface sGameStateFactory
{
	State@ createMenuState();
	State@ createLevelSelectState();
	State@ createGameState(const uint idx);
}

class sDefaultStateFactory : sGameStateFactory
{
	State@ createMenuState()
	{
		MainMenuProperties props;
		return MainMenu("empty", @props);
	}

	State@ createLevelSelectState()
	{
		PageProperties props;
		return LevelSelector("empty", @props);
	}

	State@ createGameState(const uint idx)
	{
		GameStateProperties props;
		return GameState(idx, "empty", @props);
	}
}

sGameStateFactory@ g_gameStateFactory;
