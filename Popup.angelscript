const vector2 DEFAULT_EXIT_BUTTON_POS(0.92f,0.12f);

class Popup : UILayer
{
	private string m_lastLayer;
	private string m_popupSprite;
	private UILayerManager@ m_layerManager;

	Popup(const string &in spritePath, const string &in closeButton, const string &in lastLayer,
		  UILayerManager@ layerManager, const vector2 &in exitButtonPos)
	{
		super();
		@m_layerManager = @layerManager;
		m_popupSprite = spritePath;
		const vector2 screenSize(GetScreenSize());
		addSprite("ETHFramework/sprites/eth_framework_square.png", ARGB(150,0,0,0), V2_ZERO, screenSize, V2_ZERO);
		addSprite(m_popupSprite, COLOR_WHITE, screenSize * 0.5f, V2_HALF);
		m_lastLayer = lastLayer;

		addButton("close", closeButton, exitButtonPos, V2_HALF);
		g_timeManager.pause();
	}

	void update()
	{
		UILayer::update();
		if (isButtonPressed("close") || GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
		{
			dismissSprites();
			dismissButtons();
			setButtonPressed("close", false);
		}
		if (isEverythingDismissed())
		{
			m_layerManager.setCurrentLayer(m_lastLayer);
			@m_layerManager = null;
			g_timeManager.resume();
		}
	}

	string getName() const
	{
		return "Popup";
	}

	bool isAlwaysActive() const
	{
		return true;
	}
}
