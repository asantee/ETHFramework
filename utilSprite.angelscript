void drawScaledSprite(const string sprite, const vector2 pos, const float scale, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	drawScaledSprite(sprite, pos, scale, vector2(0, 0), color, angle);
}

void drawScaledSprite(const string sprite, const vector2 pos, const float scale, const vector2 origin, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	vector2 spriteSize = GetSpriteFrameSize(sprite) * scale;
	drawSprite(sprite, pos, origin, spriteSize, color, angle);
}

void drawScaledSprite(const string sprite, const vector2 pos, const vector2 scale, const vector2 origin, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	vector2 spriteSize = GetSpriteFrameSize(sprite) * scale;
	drawSprite(sprite, pos, origin, spriteSize, color, angle);
}

void drawSprite(const string sprite, const vector2 pos, const vector2 origin, const vector2 size, const uint color = 0xFFFFFFFF, const float angle = 0.0f)
{
	SetSpriteOrigin(sprite, origin);
	DrawShapedSprite(sprite, pos, size, color, angle);
}
