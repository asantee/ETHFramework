class MainMenu : BaseState
{
	private string m_sceneName;

	MainMenu(const string &in sceneName)
	{
		m_sceneName = sceneName;
	}

	void start()
	{
		BaseState::start();
		loadScene("empty");
	}

	void preLoop()
	{
		BaseState::preLoop();
		m_layerManager.addLayer(MainMenuLayer());
		
		m_layerManager.setCurrentLayer("MainMenuLayer");
	}

	void loop()
	{
		BaseState::loop();
	}

	string getName()
	{
		return "MainMenu";
	}
}

class MainMenuLayer : UILayer
{
	MainMenuLayer()
	{
		const vector2 screenSize(GetScreenSize());

		// addButton parameters: button name id, sprite file name, normalized pos
		addButton("play_button", "sprites/main_play_game_button.png", vector2(0.75f, 0.5f));

		// addSprite parameters: sprite file name, color, pos, origin
		addSprite("sprites/game_main_title.png", COLOR_WHITE, vector2(0.25f, 0.5f) * screenSize, V2_HALF);
	}

	string getName() const
	{
		return "MainMenuLayer";
	}
}