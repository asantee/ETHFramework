class SoundPanelLayer : UILayer
{
	private SoundPanelProperties@ m_soundPanelProps;

	SoundPanelLayer(SoundPanelProperties@ soundPanelProps)
	{
		@m_soundPanelProps = @soundPanelProps;
		if (m_soundPanelProps.showSoundSwitch)
		{
			addGlobalSoundSwitch("sound_switch", m_soundPanelProps.soundSwitchOn, m_soundPanelProps.soundSwitchOff,
								 m_soundPanelProps.soundSwitchPos, m_soundPanelProps.soundSwitchOrigin);
		}
	}

	private void manageMusicSwitch()
	{
		if (!m_soundPanelProps.showMusicSwitch || !m_soundPanelProps.showSoundSwitch)
			return;

		UISwitch@ soundSwitch = cast<UISwitch@>(getButton("sound_switch"));
		if (soundSwitch is null)
			return;

		UISwitch@ musicSwitch = cast<UISwitch@>(getButton("music_switch"));

		// if the music switch is there
		if (musicSwitch !is null)
		{
			// if sound switch is off, dismiss the music switch
			if (!soundSwitch.isEnabled())
			{
				musicSwitch.dismiss();
			}
		}
		else // if the music switch ain't there
		{
			// if sound switch is on, add a music switch
			if (soundSwitch.isEnabled())
			{
				addGlobalMusicSwitch("music_switch", m_soundPanelProps.musicSwitchOn, m_soundPanelProps.musicSwitchOff,
									 m_soundPanelProps.musicSwitchPos, m_soundPanelProps.musicSwitchOrigin);
			}
		}
	}

	void update()
	{
		UILayer::update();
		manageMusicSwitch();
	}
	
	string getName() const
	{
		return "SoundPanelLayer";
	}
}
