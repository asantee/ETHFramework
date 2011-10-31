class MainMenu : BaseState
{
	private string m_sceneName;

	MainMenu(const string &in sceneName)
	{
		m_sceneName = sceneName;
	}

	void start()
	{
		BaseState::start();
		loadScene("empty");
	}

	void preLoop()
	{
		BaseState::preLoop();
	}

	void loop()
	{
		BaseState::loop();
	}

	string getName()
	{
		return "MainMenu";
	}
}
