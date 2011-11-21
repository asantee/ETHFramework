class MainMenuProperties
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
		showSoundSwitch = false;
		soundSwitchOn  = "ETHFramework/sprites/sound_high.png";
		soundSwitchOff = "ETHFramework/sprites/sound_mute.png";
		soundSwitchPos = vector2(0.0f, 1.0f);
		soundSwitchOrigin = vector2(0.0f, 1.0f);
	}
	vector2 buttonNormPos;
	vector2 titlePos;
	string titleSprite;
	string playButton;
	string exitButton;
	string soundSwitchOn;
	string soundSwitchOff;
	vector2 exitButtonNormPos;
	vector2 exitButtonOrigin;
	bool showSoundSwitch;
	vector2 soundSwitchPos;
	vector2 soundSwitchOrigin;
}
