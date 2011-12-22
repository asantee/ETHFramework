class GlobalMusicSwitch : UISwitch
{
	GlobalMusicSwitch(const string name, const string off, const vector2 pos, const float buttonScale, const vector2 origin)
	{
		super(name, off, pos, buttonScale, origin);
		if (g_musicSwitchManager.getState())
			setState(true);
		else
			setState(false);
		m_switched = false;
	}

	void update()
	{
		UISwitch::update();
		manageMusicSwitch();
	}

	private void manageMusicSwitch()
	{
		if (isSwitched())
		{
			if (isEnabled())
			{
				g_musicSwitchManager.saveMusicState(true);
				logEvent("MENU_MUSIC_SWITCH_ON");
			}
			else
			{
				g_musicSwitchManager.saveMusicState(false);
				logEvent("MENU_MUSIC_SWITCH_OFF");
			}
			#if TESTING
			print("Music state: " + g_musicSwitchManager.getState());
			#endif
		}
	}
}
