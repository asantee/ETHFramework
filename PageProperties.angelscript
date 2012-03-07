class PageProperties
{
	PageProperties()
	{
		numItems = 35;
		columns = 4;
		rows = 3;
		font = "Verdana64_shadow.fnt";
		numberOffset = vector2(0, 0);
		@itemChooser = (DefaultItemChooser());
		backButtonNormPos		= vector2(0.0f, 0.5f);
		forwardButtonNormPos	= vector2(1.0f, 0.5f);
		buttonName		= "ETHFramework/sprites/level_select_icon.png";
		lockedButton	= "ETHFramework/sprites/level_select_lock_icon.png";
		emptyButton		= "ETHFramework/sprites/level_select_icon.png";
		backButton		= "ETHFramework/sprites/level_select_back.png";
		forwardButton	= "ETHFramework/sprites/level_select_forward.png";
		useUniqueButtons = false;
		buttonSufix = "";
		buttonSound = "";
		itemSelectSound = "";
		showNumbers = true;
		fontScale = 1.0f;
	}
	uint numItems;
	uint columns;
	uint rows;
	string font;
	vector2 numberOffset;
	vector2 backButtonNormPos;
	vector2 forwardButtonNormPos;
	ItemChooser@ itemChooser;
	string buttonName;
	string lockedButton;
	string emptyButton;
	string backButton;
	string forwardButton;
	string buttonSufix;
	string buttonSound;
	string itemSelectSound;
	bool useUniqueButtons;
	bool showNumbers;
	float fontScale;
}

interface ItemChooser
{
	bool performAction(const uint itemIdx);
	bool validateItem(const uint itemIdx);
	void itemDrawCallback(const uint index, const vector2 &in pos, const vector2 &in offset);
}

class DefaultItemChooser : ItemChooser
{
	bool performAction(const uint itemIdx)
	{
		g_stateManager.setState(g_gameStateFactory.createGameState(itemIdx));
		return true;
	}

	bool validateItem(const uint itemIdx)
	{
		return true;
	}

	void itemDrawCallback(const uint index, const vector2 &in pos, const vector2 &in offset)
	{
	}
}
