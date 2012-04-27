#include "ETHFramework/IncludeModules.angelscript"

void main()
{
	g_scale.updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	@g_gameStateFactory = SMyStateFactory();
	g_stateManager.setState(g_gameStateFactory.createMenuState());
	SetPersistentResources(true);
}

class MyChooser : ItemChooser
{
	bool performAction(const uint itemIdx)
	{
		g_stateManager.setState(g_gameStateFactory.createGameState(itemIdx));
		return true;
	}

	bool validateItem(const uint itemIdx)
	{
		return ((itemIdx > 15) ? false : true);
	}

	void itemDrawCallback(const uint index, const vector2 &in pos, const vector2 &in offset)
	{
	}
}

class SMyStateFactory : SGameStateFactory
{
	State@ createMenuState()
	{
		MainMenuProperties props;
		props.showMusicSwitch = true;
		props.showSoundSwitch = true;
		return MainMenu("empty", @props);
	}

	State@ createLevelSelectState()
	{
		PageProperties props;
		@(props.itemChooser) = MyChooser();
		return LevelSelector("empty", @props);
	}

	State@ createGameState(const uint idx)
	{
		GameStateProperties props;
		return GameState(idx, "empty", @props);
	}
}

void loop()
{
	g_stateManager.runCurrentLoopFunction();

	#if TESTING
		DrawText(V2_ZERO, "" + GetFPSRate(), "Verdana20_shadow.fnt", COLOR_WHITE);
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

// called when the program is paused and then resumed (all resources were cleared, need reload)
void onResume()
{
	g_stateManager.runCurrentOnResumeFunction();
}
