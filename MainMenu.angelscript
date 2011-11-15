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
		addButton("play_button", m_props.playButton, props.buttonNormPos);

		if (m_props.exitButton != "")
		{
			addButton("exit_button", m_props.exitButton, m_props.exitButtonNormPos, m_props.exitButtonOrigin);
		}

		if (m_props.titleSprite != "")
		{
			// addSprite parameters: sprite file name, color, pos, origin
			addSprite(m_props.titleSprite, COLOR_WHITE, props.titlePos * screenSize, V2_HALF);
		}
	}
	
	void update()
	{
		UILayer::update();
		if (isButtonPressed("play_button"))
		{
			g_stateManager.setState(g_gameStateFactory.createLevelSelectState());
		}
		if (isButtonPressed("exit_button") || GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
		{
			setButtonPressed("exit_button", false);
			Exit();
		}
	}

	string getName() const
	{
		return "MainMenuLayer";
	}
}
