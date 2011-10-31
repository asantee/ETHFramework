vector2 unnormalizePos(const vector2 &in pos)
{
	return vector2(pos.x * GetScreenSize().x, pos.y * GetScreenSize().y);
}

vector2 unnormalizePos(const float x, const float y)
{
	return unnormalizePos(vector2(x, y));
}

vector2 toVector2(const vector3 &in v)
{
	return vector2(v.x, v.y);
}

string vector3ToString(const vector3 &in v3)
{
	return "(" + v3.x + ", " + v3.y + ", " + v3.z + ")";
}

string vector2ToString(const vector2 &in v2)
{
	return "(" + v2.x + ", " + v2.y + ")";
}

float dp3(const vector3 a, const vector3 b)
{
	return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
}

float dp2(const vector2 a, const vector2 b)
{
	return (a.x * b.x) + (a.y * b.y);
}

vector2 reflect(const vector2 &in dir, const vector2 &in normal)
{
	return (dir - normal * 2.0f * (dp2(normal, dir)));
}

float squaredDistance(const vector2 &in a, const vector2 &in b)
{
	const vector2 diff = a - b;
	return dp2(diff, diff);
}

vector2 getAbsolutePos(const vector2 &in pos)
{
	return pos + GetCameraPos();
}

vector2 getRightAngleVector(const vector2 &in v)
{
	const float angle = getAngle(v);
	if (angle > PIb / 2 + PIb && angle <= PI + PIb / 2)
	{
		return vector2(0,-1);
	}
	else if (angle > PIb / 2 + PI + PIb || angle <= PIb / 2)
	{
		return vector2(0,1);
	}
	else if (angle > PIb / 2 && angle <= PIb + PIb / 2)
	{
		return vector2(1,0);
	}
	else
	{
		return vector2(-1,0);
	}
}

