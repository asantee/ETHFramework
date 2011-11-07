class GameStateProperties
{
	vector2 menuButtonNormPos;
	uint menuButtonsCustomColor;
	string restartLevelButton;
	string levelNumberFont;
	string levelNumberString;
	bool showFullLevelNumberString;
	vector2 levelNumberStringNormPos;

	GameStateProperties()
	{
		menuButtonNormPos = vector2(1,0);
		menuButtonsCustomColor = COLOR_WHITE;
		restartLevelButton = "";
		levelNumberFont = "";
		showFullLevelNumberString = true;
		levelNumberString = "level ";
		levelNumberStringNormPos = vector2(0.5f, 0.1f);
	}
}
