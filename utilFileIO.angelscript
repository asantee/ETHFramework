string getResourcePath()
{
	return GetResourceDirectory();
}

// TODO: very slow
bool fileExists(const string &in fileName, const bool inPackage = true)
{
	if (inPackage)
		return (FileInPackageExists(getResourcePath() + fileName));
	else
		return (FileExists(fileName));
}
