const string ETH_FRAMEWORK_USER_DATA_FILE_NAME = "ethf.user.data";

class GlobalVolumeManager
{
	void saveVolume(const float volume)
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		userData.addValue("audio", "globalVolume", "" + volume);
		userData.writeToFile(filePath);
	}

	float loadVolume()
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		float r = 1.0f;
		userData.getFloat("audio", "globalVolume", r);
		return r;
	}
}

GlobalVolumeManager g_globalVolumeManager;
