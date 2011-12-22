const string ETH_FRAMEWORK_USER_DATA_FILE_NAME = "ethf.user.data";

class UserDataManager
{
	void saveFloat(const string &in entity, const string &in valueName, const float value)
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		userData.addValue(entity, valueName, "" + value);
		userData.writeToFile(filePath);
	}

	float loadFloat(const string &in entity, const string &in valueName, const float defaultValue)
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		float r = defaultValue;
		userData.getFloat(entity, valueName, r);
		return r;
	}
}
