class Swyper
{
	private int m_numPages;
	private int m_nextPage;
	
	private int m_currentPage;
	private vector2 m_touchHitPos;
	private float m_offset;

	Swyper(const int _numPages, const int currentPage = 0)
	{
		m_numPages = _numPages;
		m_currentPage = currentPage;
		m_offset = 0;
	}

	int getCurrentPage() const
	{
		return m_currentPage;
	}

	int getNextPage() const
	{
		if (m_offset != 0.0f)
		{
			return m_nextPage;
		}
		else
		{
			return -1;
		}
	}

	void update()
	{
		const vector2 screenSize(GetScreenSize());
		ETHInput@ input = GetInputHandle();
		const KEY_STATE touchState = input.GetTouchState(0);
		if (touchState == KS_HIT)
		{
			m_touchHitPos = input.GetTouchPos(0);
		}
		else if (touchState == KS_DOWN)
		{
			const vector2 currentTouchPos = input.GetTouchPos(0);
			m_offset = (currentTouchPos.x - m_touchHitPos.x);
			m_offset /= screenSize.x;
		}
		if (touchState == KS_RELEASE)
		{
			setCurrentPage();
			if (m_nextPage != -1 && abs(m_offset) > getMinOffsetToPageSwap())
			{
				m_offset -= 1.0f * sign(m_offset);
			}
		}
		setNextPage();
		if (abs(m_offset) < 0.0005f)
		{
			m_offset = 0.0f;
		}
	}

	vector2 getOffset()
	{
		ETHInput@ input = GetInputHandle();
		const KEY_STATE touchState = input.GetTouchState(0);
		if (touchState == KS_UP || touchState == KS_RELEASE)
		{
			m_offset *= 0.92f;
		}
		return vector2(m_offset, 0);
	}
	
	void setCurrentPage(const uint _page)
	{
		m_offset = float(_page - m_currentPage);
		m_currentPage = _page;
		setNextPage();
	}

	private void setCurrentPage()
	{
		if (abs(m_offset) > getMinOffsetToPageSwap())
		{
			if (m_offset > 0)
			{
				m_currentPage = max(0, m_currentPage - 1);
			}
			else
			{
				m_currentPage = min(m_numPages - 1, m_currentPage + 1);
			}
		}
	}

	bool isLastPage() const
	{
		return m_currentPage == m_numPages -1;
	}

	bool isFirstPage() const
	{
		return m_currentPage == 0;
	}

	private void setNextPage()
	{
		if (m_offset < 0)
		{
			m_nextPage = (isLastPage()) ? -1 : min(m_currentPage + 1, m_numPages - 1);
		}
		else if (m_offset > 0)
		{
			m_nextPage = (isFirstPage()) ? -1 : max(m_currentPage - 1, 0);
		}
		else
		{
			m_nextPage = m_currentPage;
		}
	}

	float getMinOffsetToPageSwap() const
	{
		return 0.2f;
	}
}
