#include "IncludeModules.angelscript"

void main()
{
	g_scale.updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	@g_gameStateFactory = sMyStateFactory();
	g_stateManager.setState(g_gameStateFactory.createMenuState());
	SetPersistentResources(true);
}

class sMyStateFactory : sGameStateFactory
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
		return GameState(idx, "empty", vector2(1.0f, 0.0f));
	}
}

void loop()
{
	g_stateManager.runCurrentLoopFunction();

	#if TESTING
		DrawText(vector2(0,0), "" + GetFPSRate(), "Verdana20_shadow.fnt", 0xFFFFFFFF);
	#endif
}

void preLoop()
{
	g_scale.updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	g_stateManager.runCurrentPreLoopFunction();

	SetZBuffer(false);
	SetPositionRoundUp(false);
	SetFastGarbageCollector(false);
	SetNumIterations(8, 3);
}
