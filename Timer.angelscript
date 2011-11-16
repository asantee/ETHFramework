class Timer : GameController
{
	private uint time;

	Timer()
	{
		reset();
	}

	void update()
	{
		time += g_timeManager.getLastFrameElapsedTime();
	}

	void reset()
	{
		time = 0;
	}

	void draw() {}

	uint getTime() const
	{
		return time;
	}
}
