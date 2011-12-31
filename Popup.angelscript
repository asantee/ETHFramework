const vector2 DEFAULT_EXIT_BUTTON_POS(0.92f,0.88f);

class Popup : UILayer
{
	private string m_lastLayer;
	private string m_popupSprite;
	private UILayerManager@ m_layerManager;

	bool tapScreenToClose;

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
		tapScreenToClose = false;
	}

	private bool hasReceivedCloseCommand()
	{
		if (tapScreenToClose)
		{
			if (GetInputHandle().GetTouchState(0) == KS_HIT)
				return true;
		}

		if (isButtonPressed("close"))
			return true;

		if (GetInputHandle().GetKeyState(K_BACK) == KS_HIT)
			return true;
		return false;
	}

	void update()
	{
		UILayer::update();
		if (hasReceivedCloseCommand())
		{
			dismissSprites();
			dismissButtons();
			setButtonPressed("close", false);
		}
		if (isEverythingDismissed())
		{
			if (m_layerManager !is null)
			{
				m_layerManager.setCurrentLayer(m_lastLayer);
				@m_layerManager = null;
			}
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
