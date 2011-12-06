void logEvent(const string &in event)
{
	const string str = "flurry " + event;
	ForwardCommand(str);
	#if TESTING
	print(str);
	#endif
}

void logEvent(const string &in event, EventDataPair@ dataPair0, EventDataPair@ dataPair1, EventDataPair@ dataPair2, EventDataPair@ dataPair3)
{
	logEvent(event + " " + dataPair0.m_tag + ":" + dataPair0.m_value
			 + " " + dataPair1.m_tag + ":" + dataPair1.m_value
			 + " " + dataPair2.m_tag + ":" + dataPair2.m_value
			 + " " + dataPair3.m_tag + ":" + dataPair3.m_value);
}

void logEvent(const string &in event, EventDataPair@ dataPair0, EventDataPair@ dataPair1, EventDataPair@ dataPair2)
{
	logEvent(event + " " + dataPair0.m_tag + ":" + dataPair0.m_value
			 + " " + dataPair1.m_tag + ":" + dataPair1.m_value
			 + " " + dataPair2.m_tag + ":" + dataPair2.m_value);
}

void logEvent(const string &in event, EventDataPair@ dataPair0, EventDataPair@ dataPair1)
{
	logEvent(event + " " + dataPair0.m_tag + ":" + dataPair0.m_value
			 + " " + dataPair1.m_tag + ":" + dataPair1.m_value);
}

void logEvent(const string &in event, EventDataPair@ dataPair)
{
	logEvent(event + " " + dataPair.m_tag + ":" + dataPair.m_value);
}

class EventDataPair
{
	EventDataPair(const string &in tag, const string &in value)
	{
		m_tag = tag;
		m_value = value;
	}
	string m_tag;
	string m_value;
}
