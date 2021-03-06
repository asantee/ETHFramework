﻿class GameStateProperties : SoundPanelProperties
{
	vector2 menuButtonNormPos;
	uint menuButtonsCustomColor;
	string restartLevelButton;
	string levelNumberFont;
	string levelNumberString;
	float levelNumberFontScale;
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
	uint backgroundColor;

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
		backgroundColor = ARGB(155,0,0,0);
		levelNumberFontScale = 1.0f;
	}
}
