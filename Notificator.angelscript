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
	string sound;
	uint durationMS;
	uint delay;
	uint insertionTime;
}

funcdef void NOTIFICATION_CALLBACK(Notification@ notification);

class Notificator : GameController
{
	private Notification[] m_notifications;
	private Notification[] m_stack;
	private uint m_elapsedTime;
	private vector2 m_normalizedPos;
	private vector2 m_origin;
	private string m_font;
	private float m_fontScale;
	private vector2 m_textOffset;
	private vector2 m_iconSize;
	private FloatColor m_color;
	private NOTIFICATION_CALLBACK@ m_callback;
	private NOTIFICATION_CALLBACK@ m_dismissCallback;

	Notificator(const vector2 &in normalizedPos, const vector2 &in origin,
				const float fontScale, const string &in font = "Verdana20_shadow.fnt",
				const vector2 textOffset = V2_ZERO)
	{
		m_normalizedPos = normalizedPos;
		m_origin = origin;
		m_font = font;
		m_elapsedTime = 0;
		m_fontScale = fontScale;
		m_textOffset = textOffset;
		m_iconSize = vector2(22, 22);
		m_color = FloatColor(COLOR_WHITE);
		@m_callback = null;
		@m_dismissCallback = null;
	}

	void setNotificationCallback(NOTIFICATION_CALLBACK@ callback)
	{
		@m_callback = @callback;
	}

	void setNotificationDismissCallback(NOTIFICATION_CALLBACK@ callback)
	{
		@m_dismissCallback = @callback;
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
					if (m_dismissCallback !is null)
						m_dismissCallback(@noti);
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

		Notification@ notification = @(m_notifications[0]);
		
		const float elasticScale = computeEffectScale(@notification);
		const float currentScale = g_scale.scale(elasticScale);
		const float currentFontScale = m_fontScale * currentScale;

		// compute text position adjustment in case it has an icon
		float textPitch = 0.0f;
		const vector2 iconSize = m_iconSize * currentScale;
		if (notification.icon != "")
		{
			textPitch = iconSize.x / 2.0f;
		}

		const vector2 screenSize(GetScreenSize());
		const vector2 textBoxSize = (ComputeTextBoxSize(m_font, notification.message) * currentFontScale) + vector2(textPitch, 0.0f);
		const float textWidth = textBoxSize.x;
		const float textHeight = textBoxSize.y;
		const vector2 originPos(m_normalizedPos * screenSize);

		// background left tile
		SetupSpriteRects(notification.bgImage, 3, 1);
		SetSpriteRect(notification.bgImage, 0);
		const vector2 size(GetSpriteFrameSize(notification.bgImage) * currentScale);
		const vector2 pieceOrigin(vector2(0.0f, m_origin.y));
		const vector2 piece0Pos(originPos - vector2((textWidth / 2.0f) + size.x, 0.0f));
		drawScaledSprite(notification.bgImage, piece0Pos, currentScale, pieceOrigin, m_color.getUInt());

		// background center tile
		const vector2 piece1Pos(piece0Pos + vector2(size.x, 0.0f));
		SetSpriteOrigin(notification.bgImage, pieceOrigin);
		SetSpriteRect(notification.bgImage, 1);
		DrawShapedSprite(notification.bgImage, piece1Pos, vector2(textWidth, size.y), m_color.getUInt());

		// background right tile
		const vector2 piece2Pos(piece1Pos + vector2(textWidth, 0.0f));
		SetSpriteRect(notification.bgImage, 2);
		drawScaledSprite(notification.bgImage, piece2Pos, currentScale, pieceOrigin, m_color.getUInt());

		// text
		const vector2 notificationCenter(originPos - vector2(0.0f, m_origin.y * size.y * 0.5f));
		drawCenteredText(notificationCenter + (m_textOffset * currentScale) + vector2(textPitch, 0),
						 notification.message, m_font, currentFontScale, m_color.getUInt());
		
		// icon
		if (notification.icon != "")
		{
			SetSpriteOrigin(notification.icon, V2_HALF);
			DrawShapedSprite(notification.icon,
							 notificationCenter - vector2(textWidth / 2.0f, 0.0f) + (m_textOffset * currentScale),
							 iconSize, m_color.getUInt());
		}
	}

	private float computeEffectScale(Notification@ noti)
	{
		m_color = FloatColor(COLOR_WHITE);
		const float duration = float(noti.durationMS);
		const float effectStrideMS  = min(1000.0f, duration * 0.5f);
		const float fadeoutStrideMS = min(800.0f,  duration * 0.5f);
		const float notificationElapsedTime = float(m_elapsedTime - noti.insertionTime);
		const float fadeoutElapsedTime = notificationElapsedTime - (duration - fadeoutStrideMS);
		if (notificationElapsedTime < effectStrideMS)
		{
			return elastic(max(0.0f, min(1.0f, notificationElapsedTime / effectStrideMS)));
		}
		else if (notificationElapsedTime > duration - fadeoutStrideMS)
		{
			const float alpha = 1.0f - max(0.0f, min(1.0f, fadeoutElapsedTime / fadeoutStrideMS));
			m_color = FloatColor(alpha, V3_ONE);
			return smoothEnd(alpha);
		}
		else
		{
			return 1.0f;
		}
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

				if (noti.sound != "")
					PlaySample(noti.sound);
				if (m_callback !is null)
					m_callback(@noti);
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
