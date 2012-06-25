class ImageFrame : Displayable
{
	private string m_backgroundTiles;
	private vector2 m_pos;
	private vector2 m_origin;
	private vector2 m_size;
	private bool m_borderOutside;
	private float m_scale;

	ImageFrame(const string &in backgroundTiles, const vector2 &in pos, const vector2 &in origin,
			   const vector2 &in size, const float scale = 1.0f, const bool borderOutside = false)
	{
		m_pos = pos;
		m_size = size;
		m_origin = origin;
		m_borderOutside = borderOutside;
		m_scale = scale;
		m_backgroundTiles = backgroundTiles;
	}

	void draw(const vector2 &in offset)
	{
		vector2 pos(offset + m_pos);
		vector2 sizeFix(m_size);
		SetupSpriteRects(m_backgroundTiles, 3, 3);
		SetSpriteOrigin(m_backgroundTiles, vector2(0, 0));
		const vector2 tileSize(GetSpriteFrameSize(m_backgroundTiles) * m_scale);

		if (!m_borderOutside)
		{
			sizeFix -= tileSize * 2.0f;
			pos += tileSize;
		}
		pos -= m_origin * (sizeFix + ((m_borderOutside) ? vector2(0, 0) : (tileSize * 2)));
		
		// top left corner
		SetSpriteRect(m_backgroundTiles, 0);
		drawSprite(m_backgroundTiles, pos, vector2(1, 1), tileSize);

		// top bar
		SetSpriteRect(m_backgroundTiles, 1);
		drawSprite(m_backgroundTiles, pos, vector2(0, 1), vector2(sizeFix.x, tileSize.y));

		// top right corner
		SetSpriteRect(m_backgroundTiles, 2);
		drawSprite(m_backgroundTiles, pos + vector2(sizeFix.x, 0.0f), vector2(0, 1), tileSize);

		// left bar
		SetSpriteRect(m_backgroundTiles, 3);
		drawSprite(m_backgroundTiles, pos, vector2(1, 0), vector2(tileSize.x, sizeFix.y));

		// middle
		SetSpriteRect(m_backgroundTiles, 4);
		drawSprite(m_backgroundTiles, pos, vector2(0, 0), sizeFix);

		// right bar
		SetSpriteRect(m_backgroundTiles, 5);
		drawSprite(m_backgroundTiles, pos + vector2(sizeFix.x, 0.0f), vector2(0, 0), vector2(tileSize.x, sizeFix.y));

		// bottom left corner
		SetSpriteRect(m_backgroundTiles, 6);
		drawSprite(m_backgroundTiles, pos + vector2(0.0f, sizeFix.y), vector2(1, 0), tileSize);

		// bottom bar
		SetSpriteRect(m_backgroundTiles, 7);
		drawSprite(m_backgroundTiles, pos + vector2(0.0f, sizeFix.y), vector2(0, 0), vector2(sizeFix.x, tileSize.y));

		// bottom right corner
		SetSpriteRect(m_backgroundTiles, 8);
		drawSprite(m_backgroundTiles, pos + sizeFix, vector2(0, 0), tileSize);
	}
	
	private void drawSprite(const string &in sprite, const vector2 &in pos, const vector2 &in origin, const vector2 &in size)
	{
		DrawShapedSprite(sprite, pos - (origin * size), size, 0xFFFFFFFF, 0.0f);
	}

}
