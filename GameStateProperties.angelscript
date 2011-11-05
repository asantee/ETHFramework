class GameStateProperties
{
	vector2 menuButtonNormPos;
	uint menuButtonsCustomColor;
	string restartLevelButton;

	GameStateProperties()
	{
		menuButtonNormPos = vector2(1,0);
		menuButtonsCustomColor = COLOR_WHITE;
		restartLevelButton = "";
	}
}
