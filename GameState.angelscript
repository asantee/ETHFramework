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
			logEvent("GAME_PAUSE_BUTTON_PRESSED", EventDataPair("level", "" + m_levelIndex));
			showMenuPopup();
		}
		if (m_gameMenuLayer.isButtonPressed("resume_button"))
		{
			m_gameMenuLayer.setButtonPressed("resume_button", false);
			logEvent("GAME_RESUME_BUTTON_PRESSED", EventDataPair("level", "" + m_levelIndex));
			hideMenuPopup();
		}
		handleBackButton();
	}

	void handleBackButton()
	{
		if (GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
		{
			UILayer@ currentLayer = m_layerManager.getCurrentLayer();
			if (currentLayer !is null)
			{
				if (currentLayer.getName() == "GameMenuLayer")
				{
					hideMenuPopup();
					logEvent("GAME_RESUMED_WITH_BACK_BUTTON", EventDataPair("level", "" + m_levelIndex));
				}
				else if (currentLayer.getName() == "GameLayer")
				{
					showMenuPopup();
					logEvent("GAME_PAUSED_WITH_BACK_BUTTON", EventDataPair("level", "" + m_levelIndex));
				}
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
		addButton("menu_button", m_props.menuButton, m_props.menuButtonNormPos, m_props.menuButtonNormPos);
		UIButton@ menuButton = getButton("menu_button");
		menuButton.setCustomColor(m_props.menuButtonsCustomColor);

		if (m_props.restartLevelButton != "")
		{
			const float screenWidth = GetScreenSize().x;
			const vector2 restartLevelButtonPos((screenWidth - menuButton.getSize().x) / screenWidth, 0.0f);
			addButton("restart_level", m_props.restartLevelButton, restartLevelButtonPos, vector2(1,0));
			UIButton@ restartButton = getButton("restart_level");
			restartButton.setCustomColor(m_props.menuButtonsCustomColor);
			restartButton.setSound(m_props.restartLevelButtonSound);
		}
	}

	void update()
	{
		UILayer::update();
		if (isButtonPressed("restart_level"))
		{
			setButtonPressed("restart_level", false);
			g_stateManager.setState(g_gameStateFactory.createGameState(m_currentLevel));
			logEvent("GAME_RESTART_LEVEL_BUTTON", EventDataPair("level", "" + m_currentLevel));
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
		addSprite(m_props.whiteSquareSprite, ARGB(155,0,0,0), V2_ZERO, GetScreenSize(), V2_ZERO);
		addButton("back_button", m_props.backToMainMenuButton, m_props.gameMenuExitButtonPos);
		addButton("resume_button", m_props.resumeGameButton, m_props.gameMenuResumeButtonPos);

		if (m_props.showSoundSwitch)
		{
			addGlobalSoundSwitch("sound_switch", m_props.soundSwitchOn, m_props.soundSwitchOff,
								 m_props.soundSwitchPos, m_props.soundSwitchOrigin);
		}
		if (m_props.showMusicSwitch)
		{
			addGlobalMusicSwitch("music_switch", m_props.musicSwitchOn, m_props.musicSwitchOff,
								 m_props.musicSwitchPos, m_props.musicSwitchOrigin);
		}
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
			logEvent("GAME_PAUSE_SCREEN_EXIT_BUTTON", EventDataPair("level", "" + m_levelIndex));
		}
	}

	void draw()
	{
		UILayer::draw();
		FloatColor currentLayerColor(getButton("resume_button").getColor()); currentLayerColor.setColor(V3_ONE);
		if (m_props.levelNumberFont != "")
		{
			drawCenteredText(GetScreenSize() * m_props.levelNumberStringNormPos,
							 m_props.levelNumberString + (m_levelIndex + 1),
							 m_props.levelNumberFont, g_scale.getScale(), currentLayerColor.getUInt());
		}
	}

	string getName() const
	{
		return "GameMenuLayer";
	}
}
