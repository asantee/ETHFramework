interface GlobalVolumeSwitchListener
{
	void turnGlobalVolumeOff();
	void turnGlobalVolumeOn();
}

class GlobalVolumeManager : UserDataManager
{
	//void saveFloat(const string &in entity, const string &in valueName, const float value)
	//float loadFloat(const string &in entity, const string &in valueName, const float defaultValue)

	private GlobalVolumeSwitchListener@ m_switchListener;

	void setSwitchListener(GlobalVolumeSwitchListener@ switchListener)
	{
		@m_switchListener = @switchListener;
	}

	void saveVolume(const float volume)
	{
		saveFloat("audio", "globalVolume", volume);
		if (m_switchListener !is null)
		{
			if (volume <= 0.0f)
			{
				m_switchListener.turnGlobalVolumeOff();
			}
			else
			{
				m_switchListener.turnGlobalVolumeOn();
			}
		}
	}

	float loadVolume()
	{
		return loadFloat("audio", "globalVolume", 1.0f);
	}
}

GlobalVolumeManager g_globalVolumeManager;
