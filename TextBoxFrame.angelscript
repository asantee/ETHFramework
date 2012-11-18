class TextBoxFrame : Displayable
{
	private string m_backgroundTiles;
	private string m_text;
	private string m_font;
	private vector2 m_pos;
	private vector2 m_origin;
	private float m_textScale;
	private float m_bgScale;
	private uint m_color;

	TextBoxFrame(const string &in text, const string &in font, const string &in backgroundTiles,
				 const vector2 &in pos, const vector2 &in origin, const float textScale, const float bgScale)
	{
		m_pos = pos;
		m_origin = origin;
		m_font = font;
		m_textScale = textScale;
		m_backgroundTiles = backgroundTiles;
		m_text = text;
		m_bgScale = bgScale;
		m_color = 0xFFFFFFFF;
	}

	void setColor(const uint color)
	{
		m_color = color;
	}

	uint getColor() const
	{
		return m_color;
	}

	void draw(const vector2 &in offset)
	{
		vector2 pos(m_pos);
		const vector2 size(ComputeTextBoxSize(m_font, m_text) * m_textScale);
		pos -= (m_origin * size);
		ImageFrame frame(m_backgroundTiles, pos, vector2(0, 0), size, m_bgScale, true);
		frame.setColor(m_color);
		frame.draw(offset);
		DrawText(pos, m_text, m_font, m_color, m_textScale);
	}
}
