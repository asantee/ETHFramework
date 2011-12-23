class SoundPanelProperties
{
	SoundPanelProperties()
	{
		showSoundSwitch = false;
		soundSwitchOn  = "ETHFramework/sprites/sound_high.png";
		soundSwitchOff = "ETHFramework/sprites/sound_mute.png";
		soundSwitchPos = vector2(0.0f, 1.0f);
		soundSwitchOrigin = vector2(0.0f, 1.0f);
		showMusicSwitch = false;
		musicSwitchOn  = "ETHFramework/sprites/music_on.png";
		musicSwitchOff = "ETHFramework/sprites/music_off.png";
		musicSwitchPos = vector2(0.15f, 1.0f);
		musicSwitchOrigin = vector2(0.0f, 1.0f);
	}
	string soundSwitchOn;
	string soundSwitchOff;
	bool showSoundSwitch;
	vector2 soundSwitchPos;
	vector2 soundSwitchOrigin;
	bool showMusicSwitch;
	vector2 musicSwitchPos;
	vector2 musicSwitchOrigin;
	string musicSwitchOn;
	string musicSwitchOff;
}
