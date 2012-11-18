void drawScaledSprite(const string &in sprite, const vector2 &in pos, const float scale, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	drawScaledSprite(sprite, pos, scale, vector2(0, 0), color, angle);
}

void drawScaledSprite(const string &in sprite, const vector2 &in pos, const float scale, const vector2 &in origin, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	const vector2 spriteSize(GetSpriteFrameSize(sprite) * scale);
	drawSprite(sprite, pos, origin, spriteSize, color, angle);
}

void drawScaledSprite(const string &in sprite, const vector2 &in pos, const vector2 &in scale, const vector2 &in origin, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	vector2 spriteSize = GetSpriteFrameSize(sprite) * scale;
	drawSprite(sprite, pos, origin, spriteSize, color, angle);
}

void drawSprite(const string &in sprite, const vector2 &in pos, const vector2 &in origin, const vector2 &in size, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	SetSpriteOrigin(sprite, origin);
	DrawShapedSprite(sprite, pos, size, color, angle);
}
