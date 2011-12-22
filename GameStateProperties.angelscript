class GameStateProperties
{
	vector2 menuButtonNormPos;
	uint menuButtonsCustomColor;
	string restartLevelButton;
	string levelNumberFont;
	string levelNumberString;
	bool showFullLevelNumberString;
	vector2 levelNumberStringNormPos;
	bool returnToLevelSelect;
	vector2 gameMenuExitButtonPos;
	vector2 gameMenuResumeButtonPos;
	string menuButton;
	string whiteSquareSprite;
	string backToMainMenuButton;
	string resumeGameButton;
	string restartLevelButtonSound;

	bool showMusicSwitch;
	vector2 musicSwitchPos;
	vector2 musicSwitchOrigin;
	string musicSwitchOn;
	string musicSwitchOff;

	string soundSwitchOn;
	string soundSwitchOff;
	bool showSoundSwitch;
	vector2 soundSwitchPos;
	vector2 soundSwitchOrigin;

	GameStateProperties()
	{
		menuButtonNormPos = vector2(1,0);
		menuButtonsCustomColor = COLOR_WHITE;
		restartLevelButton = "";
		levelNumberFont = "";
		showFullLevelNumberString = true;
		levelNumberString = "level ";
		levelNumberStringNormPos = vector2(0.5f, 0.1f);
		returnToLevelSelect = false;
		gameMenuExitButtonPos   = vector2(0.5f, 0.35f);
		gameMenuResumeButtonPos = vector2(0.5f, 0.65f);
		menuButton = "ETHFramework/sprites/main_menu_shortcut.png";
		whiteSquareSprite = "ETHFramework/sprites/eth_framework_square.png";
		backToMainMenuButton = "ETHFramework/sprites/back_to_main_menu.png";
		resumeGameButton = "ETHFramework/sprites/resume_button.png";
		restartLevelButtonSound = "";
		
		showMusicSwitch = false;
		musicSwitchOn  = "ETHFramework/sprites/music_on.png";
		musicSwitchOff = "ETHFramework/sprites/music_off.png";
		musicSwitchPos = vector2(0.15f, 1.0f);
		musicSwitchOrigin = vector2(0.0f, 1.0f);

		showSoundSwitch = false;
		soundSwitchOn  = "ETHFramework/sprites/sound_high.png";
		soundSwitchOff = "ETHFramework/sprites/sound_mute.png";
		soundSwitchPos = vector2(0.0f, 1.0f);
		soundSwitchOrigin = vector2(0.0f, 1.0f);
	}
}
