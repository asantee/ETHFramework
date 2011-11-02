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

bool fileExists(const string &in fileName)
{
	return (GetStringFromFileInPackage(getResourcePath() + fileName) != "");
}
