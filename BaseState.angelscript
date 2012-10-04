class BaseState : State
{
	private GameControllerManager m_controllerManager;
	private UILayerManager m_layerManager;

	void loadScene(const string &in sceneName)
	{
		LoadScene(sceneName, PRELOOP, LOOP, ONRESUME);
	}

	void loadScene(const string &in sceneName, const vector2 &in bucketSize)
	{
		LoadScene(sceneName, PRELOOP, LOOP, ONRESUME, bucketSize);
	}

	void addController(GameController@ controller)
	{
		m_controllerManager.addController(@controller);
	}

	void addLayer(UILayer@ layer)
	{
		m_layerManager.addLayer(@layer);
	}

	void setCurrentLayer(const string &in layerName)
	{
		m_layerManager.setCurrentLayer(layerName);
	}

	void start()
	{
	}

	void preLoop()
	{
		m_controllerManager.addController(@m_layerManager);
		m_controllerManager.addController(FadeInController());
	}

	void loop()
	{
		m_controllerManager.update();
		m_controllerManager.draw();
	}

	void onResume()
	{
		// implements dummy resume function
	}

	string getName()
	{
		return "BaseState";
	}
}
