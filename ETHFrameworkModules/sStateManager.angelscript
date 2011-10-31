class sStateManager
{
	void setState(State@ state)
	{
		@m_currentState = @state;
		m_currentState.start();
	}
	
	void runCurrentPreLoopFunction()
	{
		m_currentState.preLoop();
	}
	
	void runCurrentLoopFunction()
	{
		m_currentState.loop();
	}

	State@ m_currentState;
}

sStateManager g_stateManager;
