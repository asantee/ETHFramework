class Page
{
	private Button@[] m_buttons;
	private string m_soonButton;
	private uint m_first;
	private vector2 m_numberOffset;
	private TouchGapDetector m_touchGapDetector;
	private PageProperties@ m_props;

	Page(const uint firstItem, PageProperties@ props)
	{
		@m_props = @props;
		m_first = firstItem;
		m_numberOffset = g_scale.scale(props.numberOffset);

		const uint numButtons = m_props.rows * m_props.columns;
		m_buttons.resize(numButtons);
		vector2 cursor = getScreenOffset();

		const vector2 screenOffset(getScreenOffset());
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			setupItemButton(t, cursor);
			cursor.x += getButtonSize().x;
			if (cursor.x + getButtonSize().x > GetScreenSize().x - screenOffset.x + 1.0f)
			{
				cursor.x = screenOffset.x;
				cursor.y += getButtonSize().y;
			}
		}
	}

	private string getSpriteName(const uint itemIdx) const 
	{
		if (m_props.useUniqueButtons)
		{
			return (m_props.buttonName + itemIdx + m_props.buttonSufix);
		}
		else
		{
			return m_props.buttonName;
		}
	}

	private void setupItemButton(const uint t, const vector2 &in cursor)
	{
		const uint currentItem = getItem(t);
		string sprite;

		if (currentItem >= m_props.numItems)
		{
			sprite = m_props.emptyButton;
		}
		else if (!m_props.itemChooser.validateItem(currentItem) && !m_props.useUniqueButtons)
		{
			sprite = m_props.lockedButton;
		}
		else
		{
			 sprite = getSpriteName(currentItem);
		}
		@m_buttons[t] = Button(sprite, cursor, g_scale.getScale(), vector2(0, 0));
		m_buttons[t].setSound(m_props.itemSelectSound);
	}

	void update(const vector2 &in offset)
	{
		m_touchGapDetector.update();
		const bool isOffseting = (offset != vector2(0,0));
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			const uint currentItem = getItem(t);
			if (isOffseting && !m_buttons[t].isInScreen(offset))
			{
				continue;
			}
			if (isValidItem(currentItem)/* || !m_buttons[t].isAnimationFinished()*/)
			{
				m_buttons[t].update();

				// if the user had used the swyper, disable the button for this time
				if (m_touchGapDetector.getLastMaxTouchGap(0) > g_scale.scale(48.0f))
					m_buttons[t].setPressed(false);

				if (m_buttons[t].isPressed() && isValidItem(currentItem))
				{
					m_buttons[t].setPressed(false);
					if (m_props.itemChooser.validateItem(currentItem))
						m_props.itemChooser.performAction(currentItem);
					else
						m_props.itemChooser.performDenialAction(currentItem);
				}
			}
		}
	}

	bool isValidItem(const uint item) const
	{
		return item < m_props.numItems;
	}

	void draw(const vector2 &in offset)
	{
		const bool isOffseting = (offset != vector2(0,0));
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			if (isOffseting && !m_buttons[t].isInScreen(offset))
			{
				continue;
			}
			m_buttons[t].draw(offset);
			if (m_props.showNumbers)
			{
				drawNumber(t, offset);
			}
			const vector2 buttonPos = m_buttons[t].getPos();
			const vector2 halfButtonSize = m_buttons[t].getSize() * 0.5f;
			if (m_props.useUniqueButtons && !m_props.itemChooser.validateItem(getItem(t)))
			{
				drawScaledSprite(m_props.lockedButton, buttonPos + halfButtonSize + offset , g_scale.getScale(), V2_HALF, COLOR_WHITE);
			}
			m_props.itemChooser.itemDrawCallback(getItem(t), buttonPos, offset);
		}
	}
	
	private void drawNumber(const uint t, const vector2 &in offset)
	{
		const uint currentItem = getItem(t);
		if (currentItem < m_props.numItems && m_props.itemChooser.validateItem(currentItem))
		{	
			vector2 spriteSize = getButtonSize();
			vector2 pos = m_buttons[t].getPos();
			drawCenteredText(pos + m_numberOffset + offset + (spriteSize * 0.5f), "" + (getItem(t) + 1), m_props.font, g_scale.scale(m_props.fontScale), m_buttons[t].getColor());
		}
	}
	
	uint getItem(const uint t)
	{
		return t + m_first;
	}

	uint getButtonCount()
	{
		return m_buttons.length();
	}

	vector2 getButtonSize()
	{	
		return GetSpriteSize(getSpriteName(0)) * g_scale.getScale();
	}
	
	float getLineWidth()
	{
		return float(m_props.columns) * getButtonSize().x;
	}

	float getHeight()
	{
		return float(m_props.rows) * getButtonSize().y;
	}

	vector2 getScreenOffset()
	{
		return vector2((GetScreenSize().x - getLineWidth()) / 2.0f, (GetScreenSize().y - getHeight()) / 2.0f);
	}
	
	private uint getItem(const uint t) const
	{
		return m_first + t;
	}
}

class PageManager : UILayer
{
	private PageProperties@ m_props;
	private Page@[] m_pages;
	private Swyper m_swyper;
	private vector2 m_backButtonOffset;
	private vector2 m_offset;
	private vector2 pageCounterSpriteFrameSize;

	PageManager(PageProperties@ props, const int startPage = 0)
	{
		@m_props = @props;
		const uint buttonsPerPage = props.columns * props.rows;
		const uint numPages = uint(ceil(float(props.numItems) / float(buttonsPerPage)));
		m_swyper = Swyper(numPages, startPage);
		m_backButtonOffset = vector2(0,0);

		while (m_pages.length() * buttonsPerPage < m_props.numItems)
		{
			m_pages.insertLast(Page(buttonsPerPage * m_pages.length(), @m_props));
		}

		addButton("back_button", props.forwardButton, m_props.backButtonNormPos,    m_props.backButtonNormPos);
		addButton("forw_button", props.backButton,    m_props.forwardButtonNormPos, m_props.forwardButtonNormPos);

		enableBounceEffects("back_button");
		enableBounceEffects("forw_button");

		if (m_props.pageCounterSprite != "")
		{
			SetupSpriteRects(m_props.pageCounterSprite, m_props.pageCounterSpriteColumns, m_props.pageCounterSpriteRows);
			pageCounterSpriteFrameSize = GetSpriteFrameSize(m_props.pageCounterSprite);
		}
	}

	void setCurrentPage(const uint page)
	{
		m_swyper.setCurrentPage(page);
	}

	int pageOf(const uint itemIdx)
	{
		const uint buttonsPerPage = m_props.columns * m_props.rows;
		return itemIdx / buttonsPerPage;
	}

	void enableBounceEffects(const string &in buttonName)
	{
		UIButton@ button = getButton(buttonName);
		const float diff = 0.03f;
		button.setBounce(vector2(1.0f - diff, 1.0f - diff), vector2(1.0f + diff, 1.0f + diff), 400);
	}

	string getName() const
	{
		return "PageManager";
	}

	bool isAlwaysActive() const
	{
		return false;
	}

	uint getCurrentPage()
	{
		return m_swyper.getCurrentPage();
	}

	void nextPage()
	{
		if (m_swyper.getCurrentPage() < int(m_pages.length() - 1))
		{
			m_swyper.setCurrentPage(m_swyper.getCurrentPage() + 1);
		}
	}

	bool isLastPage()
	{
		return (m_swyper.isLastPage());
	}

	bool isFirstPage()
	{
		return (m_swyper.isFirstPage());
	}
	
	void priorPage()
	{
		if (m_swyper.getCurrentPage() > 0)
		{
			m_swyper.setCurrentPage(m_swyper.getCurrentPage() - 1);
		}
	}
	
	void update()
	{
		UILayer::update();
		m_swyper.update();

		UIButton@ backButton = getButton("back_button");
		bool firstPage = isFirstPage();
		if (backButton !is null)
		{
			/*if (firstPage)
			{
				backButton.setScale(g_scale.getScale() + ((abs(sin(GetTimeF() / 200.0f)) * 0.06f) * g_scale.getScale()));
			}*/
			if (backButton.isPressed())
			{
				if (firstPage)
				{
					g_stateManager.setState(g_gameStateFactory.createMenuState());
				}
				else
				{
					priorPage();
				}
				backButton.setPressed(false);
			}
		}
		if (isButtonPressed("forw_button"))
		{
			nextPage();
			setButtonPressed("forw_button", false);
		}
		fadeForwardArrows();
		m_pages[m_swyper.getCurrentPage()].update(V2_ZERO);
	}

	void fadeForwardArrows()
	{
		if (isLastPage())
		{
			UIButton@ button = getButton("forw_button");
			FloatColor newColor(button.getCustomColor());
			newColor.a *= 0.96f;
			button.setCustomColor(newColor.getUInt());
		}
		else
		{
			UIButton@ button = getButton("forw_button");
			FloatColor newColor(button.getCustomColor());
			newColor.a += 0.05f;
			if (newColor.a > 1.0f)
				newColor.a = 1.0f;
			button.setCustomColor(newColor.getUInt());
		}
	}

	float getGlobalOffset() const
	{
		const float fNumPages = float(m_pages.length());
		float globalOffset = float(m_swyper.getCurrentPage()) / fNumPages;
		const float piece = 1.0f / fNumPages;
		return (globalOffset + (piece *-m_offset.x)) * 2.0f;
	}

	void draw()
	{
		UILayer::draw();
		const vector2 screenSize(GetScreenSize());
		const int nextPage = m_swyper.getNextPage();
		
		float offsetX = m_swyper.getOffset().x;
		if (nextPage ==-1)
		{
			offsetX *= 0.3333f;
		}
		const uint currentPage = m_swyper.getCurrentPage();
		m_pages[currentPage].draw(vector2(offsetX * screenSize.x, 0));
		
		if (nextPage != -1)
		{
			m_offset = m_swyper.getOffset();
			const float nextPageOffset = (nextPage > int(currentPage)) ? screenSize.x : -screenSize.x;
			const vector2 offset(vector2((m_offset.x * screenSize.x) + nextPageOffset, 0));
			m_pages[nextPage].draw(offset);
		}
		if (m_pages.length() > 1 && m_props.pageCounterSprite != "")
		{
			drawPageCounter(currentPage);
		}
	}

	void drawPageCounter(const uint currentPage)
	{
		const uint numPages = m_pages.length();
		const vector2 spriteOffset(g_scale.scale(pageCounterSpriteFrameSize * vector2(1,0)));
		const float fNumPages = float(m_pages.length());
		vector2 rail((m_props.pageCounterNormalizedPos * GetScreenSize()) - (fNumPages * spriteOffset * 0.5f));
		const uint lastFrame = (m_props.pageCounterSpriteColumns * m_props.pageCounterSpriteRows) - 1;
		SetupSpriteRects(m_props.pageCounterSprite, m_props.pageCounterSpriteColumns, m_props.pageCounterSpriteRows);
		for (uint t = 0; t < numPages; t++)
		{
			SetSpriteRect(m_props.pageCounterSprite, (currentPage == t) ? t : lastFrame);
			drawScaledSprite(m_props.pageCounterSprite, rail, g_scale.getScale(), V2_ZERO, m_props.pageCounterColor);
			rail += spriteOffset;
		}
	}
}
