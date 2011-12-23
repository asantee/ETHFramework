string getResourcePath()
{
	string r;
	#if ANDROID
		r = "assets/";
	#endif
	#if APPLE_IOS
		r = "assets/";
	#endif
	#if WINDOWS
		r = GetProgramPath();
	#endif
	return r;
}

// TODO: very slow
bool fileExists(const string &in fileName, const bool inPackage = true)
{
	if (inPackage)
		return (GetStringFromFileInPackage(getResourcePath() + fileName) != "");
	else
		return (GetStringFromFile(fileName) != "");
}
