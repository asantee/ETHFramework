class GlobalSoundSwitch : UISwitch
{
	GlobalSoundSwitch(const string name, const string off, const vector2 pos, const float buttonScale, const vector2 origin)
	{
		super(name, off, pos, buttonScale, origin);
		if (GetGlobalVolume() == 0.0f)
			setState(false);
		else
			setState(true);
		m_switched = false;
	}

	void update()
	{
		UISwitch::update();
		manageSoundSwitch();
	}

	private void manageSoundSwitch()
	{
		if (isSwitched())
		{
			if (isEnabled())
			{
				SetGlobalVolume(1.0f);
				logEvent("MENU_SOUND_SWITCH_ON");
			}
			else
			{
				SetGlobalVolume(0.0f);
				logEvent("MENU_SOUND_SWITCH_OFF");
			}
			g_globalVolumeManager.saveVolume(GetGlobalVolume());
			#if TESTING
			print("Global volume: " + GetGlobalVolume());
			#endif
		}
	}
}
