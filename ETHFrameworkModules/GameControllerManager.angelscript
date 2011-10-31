class GameControllerManager
{
	private GameController@[] controllers;

	void addController(GameController@ controller)
	{
		controllers.insertLast(controller);
	}

	void update()
	{
		const int size = controllers.length();
		for (int t = 0; t < size; t++)
		{
			controllers[t].update();
		}
	}
	
	void draw()
	{		
		const int size = controllers.length();
		for (int t = 0; t < size; t++)
		{
			controllers[t].draw();
		}
	}
}
