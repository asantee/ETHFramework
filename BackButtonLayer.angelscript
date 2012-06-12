class BackButtonLayer : UILayer
{
	BackButtonLayer()
	{
		addBackButton(vector2(0.05f, 0.5f), true);
	}
	
	BackButtonLayer(const vector2 &in backButtonPos, const bool bounceEffect = true)
	{
		addBackButton(backButtonPos, bounceEffect);
	}
	
	private void addBackButton(const vector2 &in pos, const bool bounceEffect)
	{
		addButton("back", "sprites/back_button_credits_screen.png", pos, pos);
		if (bounceEffect)
			setCreditButtonBounceEffect(getButton("back"));
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