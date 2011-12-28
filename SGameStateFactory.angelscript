interface SGameStateFactory
{
	State@ createMenuState();
	State@ createLevelSelectState();
	State@ createGameState(const uint idx);
}

class SDefaultStateFactory : SGameStateFactory
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

SGameStateFactory@ g_gameStateFactory;
