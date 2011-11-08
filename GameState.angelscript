class GameState : BaseState
{
	private string m_sceneName;
	private GameLayer@ m_gameLayer;
	private GameMenuLayer@ m_gameMenuLayer;
	private uint m_levelIndex;
	private GameStateProperties@ m_props;

	GameState(const uint levelIndex, const string &in sceneName, GameStateProperties@ props)
	{
		m_levelIndex = levelIndex;
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
		@m_gameLayer = GameLayer(@m_props, m_levelIndex);
		@m_gameMenuLayer = GameMenuLayer(@m_props, m_levelIndex);

		m_layerManager.addLayer(@m_gameLayer);
		m_layerManager.addLayer(@m_gameMenuLayer);

		m_layerManager.setCurrentLayer("GameLayer");
		g_timeManager.resume();
	}

	void loop()
	{
		BaseState::loop();
		if (m_gameLayer.isButtonPressed("menu_button"))
		{
			m_gameLayer.setButtonPressed("menu_button", false);
			showMenuPopup();
		}
		if (m_gameMenuLayer.isButtonPressed("resume_button"))
		{
			m_gameMenuLayer.setButtonPressed("resume_button", false);
			hideMenuPopup();
		}
		handleBackButton();
	}

	void handleBackButton()
	{
		if (GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
		{
			UILayer@ currentLayer = m_layerManager.getCurrentLayer();
			bool willShowGameMenuLayerPopup = true;
			if (currentLayer !is null)
			{
				if (currentLayer.getName() == "GameMenuLayer")
				{
					hideMenuPopup();
				}
				else
				{
					showMenuPopup();
				}
			}
			else
			{
				willShowGameMenuLayerPopup = true;
			}
		}
	}

	void showMenuPopup()
	{
		m_layerManager.setCurrentLayer("GameMenuLayer");
		g_timeManager.pause();
	}

	void hideMenuPopup()
	{
		m_gameMenuLayer.hide(true);
		m_layerManager.setCurrentLayer("GameLayer");
		g_timeManager.resume();
	}

	string getName()
	{
		return "GameState";
	}
}

class GameLayer : UILayer
{
	private GameStateProperties@ m_props;
	private uint m_currentLevel;

	GameLayer(GameStateProperties@ props, const uint currentLevel)
	{
		m_currentLevel = currentLevel;
		@m_props = @props;

		// addButton parameters: button name id, sprite file name, normalized pos, normalized origin
		addButton("menu_button", "sprites/main_menu_shortcut.png", m_props.menuButtonNormPos, m_props.menuButtonNormPos);
		UIButton@ menuButton = getButton("menu_button");
		menuButton.setCustomColor(m_props.menuButtonsCustomColor);

		if (m_props.restartLevelButton != "")
		{
			const float screenWidth = GetScreenSize().x;
			const vector2 restartLevelButtonPos((screenWidth - menuButton.getSize().x) / screenWidth, 0.0f);
			addButton("restart_level", m_props.restartLevelButton, restartLevelButtonPos, vector2(1,0));
			UIButton@ restartButton = getButton("restart_level");
			restartButton.setCustomColor(m_props.menuButtonsCustomColor);
		}
	}

	void update()
	{
		UILayer::update();
		if (isButtonPressed("restart_level"))
		{
			setButtonPressed("restart_level", false);
			g_stateManager.setState(g_gameStateFactory.createGameState(m_currentLevel));
		}
	}

	string getName() const
	{
		return "GameLayer";
	}
}

class GameMenuLayer : UILayer
{
	private GameStateProperties@ m_props;
	private uint m_levelIndex;

	GameMenuLayer(GameStateProperties@ props, const uint levelIndex)
	{
		m_levelIndex = levelIndex;
		@m_props = @props;
		addSprite("sprites/square.png", ARGB(155,0,0,0), V2_ZERO, GetScreenSize(), V2_ZERO);
		addButton("back_button",   "sprites/back_to_main_menu.png", m_props.gameMenuExitButtonPos);
		addButton("resume_button", "sprites/resume_button.png",     m_props.gameMenuResumeButtonPos);
	}

	void update()
	{
		UILayer::update();
		if (isButtonPressed("back_button"))
		{
			setButtonPressed("back_button", false);
			if (m_props.returnToLevelSelect)
				g_stateManager.setState(g_gameStateFactory.createLevelSelectState());
			else
				g_stateManager.setState(g_gameStateFactory.createMenuState());
			hide(true);
		}
	}

	void draw()
	{
		UILayer::draw();
		const uint currentLayerColor = getButton("resume_button").getColor();
		drawCenteredText(GetScreenSize() * m_props.levelNumberStringNormPos,
						 m_props.levelNumberString + (m_levelIndex + 1),
						 m_props.levelNumberFont, g_scale.getScale(), currentLayerColor);
	}

	string getName() const
	{
		return "GameMenuLayer";
	}
}
