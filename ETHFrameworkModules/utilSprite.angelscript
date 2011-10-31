void drawScaledSprite(const string sprite, const vector2 pos, const float scale, const uint color = 0xFFFFFFFF)
{
	drawScaledSprite(sprite, pos, scale, vector2(0, 0), color);
}

void drawScaledSprite(const string sprite, const vector2 pos, const float scale, const vector2 origin, const uint color = 0xFFFFFFFF)
{
	vector2 spriteSize = GetSpriteFrameSize(sprite) * scale;
	drawSprite(sprite, pos, origin, spriteSize, color);
}

void drawSprite(const string sprite, const vector2 pos, const vector2 origin, const vector2 size, const uint color = 0xFFFFFFFF)
{
	SetSpriteOrigin(sprite, origin);
	DrawShapedSprite(sprite, pos, size, color);
}
