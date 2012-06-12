bool isPointInScreen(vector2 p)
{
	p -= GetCameraPos();
	if (p.x < 0 || p.y < 0 || p.x > GetScreenSize().x || p.y > GetScreenSize().y)
		return false;
	else
		return true;
}

bool isRectInScreen(vector2 pos, const vector2 &in size, const vector2 &in origin = V2_ZERO)
{
	pos -= size * origin;
	pos -= GetCameraPos();
	if (pos.x + size.x < 0 || pos.y + size.y < 0 || pos.x > GetScreenSize().x || pos.y > GetScreenSize().y)
		return false;
	else
		return true;
}

bool isPointInRect(const vector2 &in p, const vector2 &in pos, const vector2 &in size, const vector2 &in origin)
{	
	vector2 posRelative = vector2(pos.x - size.x * origin.x, pos.y - size.y * origin.y);
	if (p.x < posRelative.x || p.x > posRelative.x + size.x || p.y < posRelative.y || p.y > posRelative.y + size.y)
		return false;
	else
		return true;
}

bool isPointInRect(const vector2 &in p, const vector2 &in pos, const vector2 &in size)
{
	return isPointInRect(p, pos, size, vector2(0, 0));
}

bool isPointInCircle(const vector2 &in p, const vector2 &in pos, const float radius)
{
	return (squaredDistance(p, pos) < radius * radius);
}
