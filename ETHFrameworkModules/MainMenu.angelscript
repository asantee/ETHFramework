class MainMenu : BaseState
{
	private string m_sceneName;
	private vector2 m_buttonNormPos;
	private vector2 m_titlePos;
	private UILayer@ m_mainMenuLayer;

	MainMenu(const string &in sceneName, const vector2 &in buttonNormPos, const vector2 &in titlePos)
	{
		m_sceneName = sceneName;
		m_buttonNormPos = buttonNormPos;
		m_titlePos = titlePos;
	}

	void start()
	{
		BaseState::start();
		loadScene(m_sceneName);
	}

	void preLoop()
	{
		BaseState::preLoop();
		@m_mainMenuLayer = MainMenuLayer(m_buttonNormPos, m_titlePos);

		m_layerManager.addLayer(@m_mainMenuLayer);

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
	MainMenuLayer(const vector2 &in buttonNormPos, const vector2 &in titlePos)
	{
		const vector2 screenSize(GetScreenSize());

		// addButton parameters: button name id, sprite file name, normalized pos
		addButton("play_button", "sprites/main_play_game_button.png", buttonNormPos);

		// addSprite parameters: sprite file name, color, pos, origin
		addSprite("sprites/game_main_title.png", COLOR_WHITE, titlePos * screenSize, V2_HALF);
	}
	
	void update()
	{
		UILayer::update();
		if (isButtonPressed("play_button"))
		{
			g_stateManager.setState(g_gameStateFactory.createLevelSelectState());
		}
	}

	string getName() const
	{
		return "MainMenuLayer";
	}
}
