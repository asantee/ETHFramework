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
		return MainMenu("empty", vector2(0.75f, 0.5f), vector2(0.25f, 0.5f));
	}

	State@ createLevelSelectState()
	{
		PageProperties props;
		return LevelSelector("empty", @props);
	}

	State@ createGameState(const uint idx)
	{
		return GameState(idx, "empty", vector2(1.0f, 0.0f));
	}
}

sGameStateFactory@ g_gameStateFactory;
