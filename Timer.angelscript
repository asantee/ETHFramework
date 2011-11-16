class Timer : GameController
{
	private uint time;

	Timer()
	{
		time = 0;
	}

	void update()
	{
		time += g_timeManager.getLastFrameElapsedTime();
	}

	void draw() {}

	uint getTime() const
	{
		return time;
	}
}
