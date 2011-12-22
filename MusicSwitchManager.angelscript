class MusicSwitchManager : UserDataManager
{
	private bool m_state;
	private bool m_stateLoaded;
	
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
	}

	bool loadMusicState()
	{
		m_stateLoaded = true;
		m_state = loadBoolean("audio", "musicEnabled", true);
		return m_state;
	}
}

MusicSwitchManager g_musicSwitchManager;
