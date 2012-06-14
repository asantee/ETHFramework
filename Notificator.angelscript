class Notification
{
	Notification()
	{
		message = "none";
		durationMS = 3000;
		delay = 0;
		insertionTime = 0;
		bgImage = "ETHFramework/sprites/notificationbg.png";
	}
	string message;
	string bgImage;
	string icon;
	uint durationMS;
	uint delay;
	uint insertionTime;
}

class Notificator : GameController
{
	private Notification[] m_notifications;
	private Notification[] m_stack;
	private uint m_elapsedTime;
	private vector2 m_normalizedPos;
	private vector2 m_origin;
	private string m_font;
	private float m_fontScale;

	Notificator(const vector2 &in normalizedPos, const vector2 &in origin, const float fontScale, const string &in font = "Verdana20_shadow.fnt")
	{
		m_normalizedPos = normalizedPos;
		m_origin = origin;
		m_font = font;
		m_elapsedTime = 0;
		m_fontScale = fontScale;
	}

	void update()
	{
		m_elapsedTime += GetLastFrameElapsedTime();
		updateStack();
		const uint count = m_notifications.length();
		for (uint t = 0; t < count; t++)
		{
			Notification@ noti = @(m_notifications[t]);
			if (t == 0)
			{
				if (m_elapsedTime - noti.insertionTime > noti.durationMS)
				{
					m_notifications.removeAt(t);
					break;
				}
			}
			else
			{
				// hold on
				noti.insertionTime = m_elapsedTime;
			}
		}
	}

	void draw()
	{
		if (m_notifications.length() == 0)
			return;

		const vector2 screenSize(GetScreenSize());
		Notification@ notification = @(m_notifications[0]);
		const vector2 textBoxSize = g_scale.scale(ComputeTextBoxSize(m_font, notification.message));
		const float textWidth = textBoxSize.x;
		const float textHeight = textBoxSize.y;
		const vector2 originPos(m_normalizedPos * screenSize);
		if (notification.bgImage != "")
		{
			SetupSpriteRects(notification.bgImage, 3, 1);
			SetSpriteRect(notification.bgImage, 0);
			const vector2 size(g_scale.scale(GetSpriteFrameSize(notification.bgImage)));
			const vector2 pieceOrigin(vector2(0.0f, m_origin.y));
			const vector2 piece0Pos(originPos - vector2((textWidth / 2.0f) + size.x, 0.0f));
			drawScaledSprite(notification.bgImage, piece0Pos, g_scale.getScale(), pieceOrigin, COLOR_WHITE);

			const vector2 piece1Pos(piece0Pos + vector2(size.x, 0.0f));
			SetSpriteOrigin(notification.bgImage, pieceOrigin);
			SetSpriteRect(notification.bgImage, 1);
			DrawShapedSprite(notification.bgImage, piece1Pos, vector2(textWidth, size.y), COLOR_WHITE);
			
			const vector2 piece2Pos(piece1Pos + vector2(textWidth, 0.0f));
			SetSpriteRect(notification.bgImage, 2);
			drawScaledSprite(notification.bgImage, piece2Pos, g_scale.getScale(), pieceOrigin, COLOR_WHITE);
		}
		drawCenteredText(originPos + vector2(0.0f, textHeight / 2.0f), notification.message, m_font, g_scale.scale(m_fontScale));
	}

	private void updateStack()
	{
		const uint countInStack = m_stack.length();
		for (uint t = 0; t < countInStack; t++)
		{
			Notification@ noti = @(m_stack[t]);
			if (m_elapsedTime - noti.insertionTime > noti.delay)
			{
				noti.insertionTime = m_elapsedTime;
				m_notifications.insertLast(noti);
				m_stack.removeAt(t);
				break;
			}
		}
	}

	void notify(Notification@ notification)
	{
		notification.insertionTime = m_elapsedTime;
		m_stack.insertLast(notification);
	}
}
