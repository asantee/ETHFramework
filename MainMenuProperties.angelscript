class MainMenuProperties : SoundPanelProperties
{
	MainMenuProperties()
	{
		buttonNormPos = vector2(0.75f, 0.5f);
		titlePos = vector2(0.25f, 0.5f);
		titleSprite = "ETHFramework/sprites/game_main_title.png";
		playButton  = "ETHFramework/sprites/main_play_game_button.png";
		exitButton  = "";
		exitButtonNormPos = V2_ZERO;
		exitButtonOrigin =  V2_ZERO;
	}
	vector2 buttonNormPos;
	vector2 titlePos;
	string titleSprite;
	string playButton;
	string exitButton;
	vector2 exitButtonNormPos;
	vector2 exitButtonOrigin;
}
