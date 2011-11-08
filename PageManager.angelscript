class Page
{
	private Button@[] m_buttons;
	private string m_buttonBg;
	private string m_lockedButton;
	private string m_soonButton;
	private string m_emptyButton;
	private uint m_first;
	private uint m_numItems;
	private uint m_rows;
	private uint m_columns;
	private string m_font;
	private vector2 m_numberOffset;
	private PERFORM_ACTION@ m_performAction;
	private VALIDATE_ITEM@ m_validateItem;
	private ITEM_DRAW_CALLBACK@ m_itemDrawCallback;

	Page(const uint firstItem, PageProperties@ props)
	{
		m_first = firstItem;
		m_numItems = props.numItems;
		m_font = props.font;
		m_rows = props.rows;
		m_columns = props.columns;
		m_numberOffset = g_scale.scale(props.numberOffset);
		@m_performAction = @(props.performAction);
		@m_validateItem = @(props.validateItem);
		@m_itemDrawCallback = @(props.itemDrawCallback);
		m_buttonBg     = props.buttonBg;
		m_lockedButton = props.lockedButton;
		m_emptyButton  = props.emptyButton;

		// fat ball
		LoadSprite(m_buttonBg);
		LoadSprite(m_lockedButton);

		const uint numButtons = m_rows * m_columns;
		m_buttons.resize(numButtons);
		vector2 cursor = getScreenOffset();

		const vector2 screenOffset(getScreenOffset());
		for (uint t = 0; t < m_buttons.length(); t++)
		{
			setupItemButton(t, cursor);
			cursor.x += getButtonSize().x;
			if (cursor.x + getButtonSize().x > GetScreenSize().x - screenOffset.x)
			{
				cursor.x = screenOffset.x;
				cursor.y += getButtonSize().y;
			}
		}
	}

	private void setupItemButton(const uint t, const vector2 &in cursor)
	{
		string sprite = m_buttonBg;
		const uint currentItem = getItem(t);
		if (currentItem >= m_numItems)
		{
			sprite = m_emptyButton;
		}
		else if (!m_validateItem(currentItem))
		{
			sprite = m_lockedButton;
		}
		@m_buttons[t] = Button(sprite, cursor, g_scale.getScale(), vector2(0, 0));
	}

	void update(const vector2 &in offset)
	{
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
				if (m_buttons[t].isPressed() && isValidItem(currentItem) && m_validateItem(currentItem))
				{
					m_buttons[t].setPressed(false);
					m_performAction(currentItem);
				}
			}
		}
	}

	bool isValidItem(const uint item) const
	{
		return item < m_numItems;
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
			// drawStars(t, buttons[t].getPos() + offset);
			drawNumber(t, offset);
			m_itemDrawCallback(getItem(t), m_buttons[t].getPos(), offset);
		}
	}
	
	private void drawNumber(const uint t, const vector2 &in offset)
	{
		const uint currentItem = getItem(t);
		if (currentItem < m_numItems && m_validateItem(currentItem))
		{	
			vector2 spriteSize = getButtonSize();
			vector2 pos = m_buttons[t].getPos();
			drawCenteredText(pos + m_numberOffset + offset + (spriteSize * 0.5f), "" + (getItem(t) + 1), m_font, g_scale.getScale(), m_buttons[t].getColor());
		}
	}
	
	uint getItem(const uint t)
	{
		return t + m_first;
	}

	/*private void drawStars(const uint t, const vector2 pos)
	{
		const int score = gScoreManager.getScore(getItem(t));
		if (score > 0)
		{
			const string sprite = "sprites/star_" + score + ".png";
			LoadSprite(sprite);
			DrawShapedSprite("sprites/star_" + score + ".png", pos, GetSpriteSize(sprite) * gScale.getScale(), 0xFFFFFFFF);
		}
	}*/

	uint getButtonCount()
	{
		return m_buttons.length();
	}

	vector2 getButtonSize()
	{	
		return GetSpriteSize(m_buttonBg) * g_scale.getScale();
	}
	
	float getLineWidth()
	{
		return float(m_columns) * getButtonSize().x;
	}

	float getHeight()
	{
		return float(m_rows) * getButtonSize().y;
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

	PageManager(PageProperties@ props)
	{
		@m_props = @props;
		const uint buttonsPerPage = props.columns * props.rows;
		const uint numPages = uint(ceil(float(props.numItems) / float(buttonsPerPage)));
		m_swyper = Swyper(numPages);
		m_backButtonOffset = vector2(0,0);

		while (m_pages.length() * buttonsPerPage < m_props.numItems)
		{
			m_pages.insertLast(Page(buttonsPerPage * m_pages.length(), @m_props));
		}

		addButton("back_button", "sprites/level_select_forward.png", m_props.backButtonNormPos,    m_props.backButtonNormPos);
		addButton("forw_button", "sprites/level_select_back.png",    m_props.forwardButtonNormPos, m_props.forwardButtonNormPos);
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
			if (firstPage)
			{
				backButton.setScale(g_scale.getScale() + ((abs(sin(GetTimeF() / 200.0f)) * 0.06f) * g_scale.getScale()));
			}
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

	void draw()
	{
		UILayer::draw();
		const vector2 screenSize(GetScreenSize());
		m_pages[m_swyper.getCurrentPage()].update(V2_ZERO);
		const int nextPage = m_swyper.getNextPage();
		
		float offsetX = m_swyper.getOffset().x;
		if (nextPage ==-1)
		{
			offsetX *= 0.3333f;
		}
		m_pages[m_swyper.getCurrentPage()].draw(vector2(offsetX * screenSize.x, 0));
		if (nextPage != -1)
		{
			const float nextPageOffset = (nextPage > int(m_swyper.getCurrentPage())) ? screenSize.x : -screenSize.x;
			const vector2 offset(vector2((m_swyper.getOffset().x * screenSize.x) + nextPageOffset, 0));
			m_pages[nextPage].draw(offset);
		}
	}
}
