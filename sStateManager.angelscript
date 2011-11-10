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

	string getCurrentStateName() const
	{
		if (m_currentState !is null)
			return m_currentState.getName();
		else
			return "";
	}

	private State@ m_currentState;
}

sStateManager g_stateManager;
