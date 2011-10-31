class BaseState : State
{
	private GameControllerManager m_controllerManager;
	private UILayerManager m_layerManager;

	void loadScene(const string &in sceneName)
	{
		LoadScene(sceneName, PRELOOP, LOOP);
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

	string getName()
	{
		return "baseState";
	}
}
