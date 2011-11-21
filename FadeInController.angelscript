class FadeInController : GameController
{
	private uint time;
	private uint startTime;
	private string spriteName;
	private bool done;

	FadeInController()
	{
		time = 700;
		startTime = GetTime();
		spriteName = "ETHFramework/sprites/eth_framework_square.png";
		done = false;
		start();
	}

	private void start()
	{
		LoadSprite(spriteName);
		DrawShapedSprite(spriteName, vector2(0,0), GetScreenSize(), 0xFF000000);
		startTime = GetTime();
	}

	void update()
	{
	}

	void draw()
	{
		if (!isFinished() && !done)
		{
			const uint elapsedTime = GetTime() - startTime;
			const float bias = 1.0f - (float(elapsedTime) / float(time));
			LoadSprite(spriteName);
			DrawShapedSprite(spriteName, vector2(0,0), GetScreenSize(), ARGB(uint(bias*255.0f),0,0,0));
		}
		else
		{
			done = true;
		}
	}

	bool isFinished()
	{
		return ((GetTime() - startTime) >= time);
	}
}
