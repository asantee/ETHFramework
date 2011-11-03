class MainMenu : BaseState
{
	private string m_sceneName;
	private MainMenuProperties@ m_props;
	private UILayer@ m_mainMenuLayer;

	MainMenu(const string &in sceneName, MainMenuProperties@ props)
	{
		m_sceneName = sceneName;
		@m_props = @props;
	}

	void start()
	{
		BaseState::start();
		loadScene(m_sceneName);
	}

	void preLoop()
	{
		BaseState::preLoop();
		@m_mainMenuLayer = MainMenuLayer(@m_props);

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
	private MainMenuProperties@ m_props;

	MainMenuLayer(MainMenuProperties@ props)
	{
		@m_props = @props;
		const vector2 screenSize(GetScreenSize());

		// addButton parameters: button name id, sprite file name, normalized pos
		addButton("play_button", "sprites/main_play_game_button.png", props.buttonNormPos);

		// addSprite parameters: sprite file name, color, pos, origin
		addSprite("sprites/game_main_title.png", COLOR_WHITE, props.titlePos * screenSize, V2_HALF);
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
