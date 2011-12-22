class GlobalVolumeManager : UserDataManager
{
	//void saveFloat(const string &in entity, const string &in valueName, const float value)
	//float loadFloat(const string &in entity, const string &in valueName, const float defaultValue)

	void saveVolume(const float volume)
	{
		saveFloat("audio", "globalVolume", volume);
	}

	float loadVolume()
	{
		return loadFloat("audio", "globalVolume", 1.0f);
	}
}

GlobalVolumeManager g_globalVolumeManager;
