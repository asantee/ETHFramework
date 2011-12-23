interface MusicSwitchListener
{
	void turnMusicOff();
	void turnMusicOn();
}

class MusicSwitchManager : UserDataManager
{
	private bool m_state;
	private bool m_stateLoaded;
	private MusicSwitchListener@ m_switchListener;

	void setSwitchListener(MusicSwitchListener@ switchListener)
	{
		@m_switchListener = @switchListener;
	}

	MusicSwitchManager()
	{
		m_state = false;
		m_stateLoaded = false;
	}

	bool getState()
	{
		if (!m_stateLoaded)
			loadMusicState();
		return m_state;
	}

	void saveMusicState(const bool state)
	{
		m_state = state;
		saveBoolean("audio", "musicEnabled", state);
		if (m_switchListener !is null)
		{
			if (!state)
			{
				m_switchListener.turnMusicOff();
			}
			else
			{
				m_switchListener.turnMusicOn();
			}
		}
	}

	bool loadMusicState()
	{
		m_stateLoaded = true;
		m_state = loadBoolean("audio", "musicEnabled", true);
		return m_state;
	}
}

MusicSwitchManager g_musicSwitchManager;
