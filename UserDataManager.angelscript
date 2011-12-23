const string ETH_FRAMEWORK_USER_DATA_FILE_NAME = "ethf.user.data";

class UserDataManager
{
	void saveValue(const string &in entity, const string &in valueName, const string &in value)
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		userData.addValue(entity, valueName, value);
		userData.writeToFile(filePath);
	}

	string loadValue(const string &in entity, const string &in valueName, const string &in defaultValue)
	{
		const string filePath = GetExternalStoragePath() + ETH_FRAMEWORK_USER_DATA_FILE_NAME;
		const string content = GetStringFromFile(filePath);
		enmlFile userData;
		userData.parseString(content);
		const string value = userData.get(entity, valueName);
		return (value != "") ? value : defaultValue;
	}

	void saveFloat(const string &in entity, const string &in valueName, const float value)
	{
		saveValue(entity, valueName, "" + value);
	}

	float loadFloat(const string &in entity, const string &in valueName, const float defaultValue)
	{
		const string value = loadValue(entity, valueName, "" + defaultValue);
		return ParseFloat(value);
	}

	void saveBoolean(const string &in entity, const string &in valueName, const bool value)
	{
		saveValue(entity, valueName, value ? "true" : "false");
	}

	bool loadBoolean(const string &in entity, const string &in valueName, const bool defaultValue)
	{
		const string value = loadValue(entity, valueName, "" + defaultValue);
		return isTrue(value);
	}

	bool isTrue(const string &in value)
	{
		if (value == "true" || value == "TRUE" || value == "YES" || value == "yes")
			return true;
		else
			return false;
	}
}
