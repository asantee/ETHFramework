void drawCenteredText(const vector2 posAbsolute, const string text, const string font, const float scale = 1.0f, const uint color = 0xFFFFFFFF)
{
	const vector2 textBoxSize = ComputeTextBoxSize(font, text) * scale;
	vector2 posRelative =  posAbsolute - textBoxSize / 2;
	DrawText(posRelative, text, font, color, scale);
}

void drawCenteredFadingText(const vector2 posAbsolute, const string text, const string font, const uint time, const float scale = 1.0f, const uint color = 0xFFFFFFFF)
{
	const vector2 textBoxSize = ComputeTextBoxSize(font, text) * scale;
	vector2 posRelative =  posAbsolute - textBoxSize / 2;
	DrawFadingText(posRelative, text, font, color, time, scale);
}
