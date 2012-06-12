class BackButtonLayer : UILayer
{
	BackButtonLayer()
	{
		addBackButton(vector2(0.05f, 0.5f));
	}
	
	BackButtonLayer(const vector2 &in backButtonPos)
	{
		addBackButton(backButtonPos);
	}
	
	private void addBackButton(const vector2 &in pos)
	{
		addButton("back", "sprites/back_button_credits_screen.png", pos, pos);
	}

	bool isBackButtonPressed() const
	{
		return (isButtonPressed("back") || GetInputHandle().GetKeyState(K_BACK) == KS_HIT);
	}

	string getName() const
	{
		return "BackButtonLayer";
	}
}