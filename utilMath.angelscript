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

float clamp(const float val, const float minVal, const float maxVal)
{
	return (val < minVal) ? minVal : ((val > maxVal) ? maxVal : val);
}

vector2 clamp(const vector2 &in val, const vector2 &in minVal, const vector2 &in maxVal)
{
	return vector2(clamp(val.x, minVal.x, maxVal.x), clamp(val.y, minVal.y, maxVal.y));
}

vector2 capVector(const vector2 &in v, const float length)
{
	if (dp2(v, v) > length * length)
	{
		return normalize(v) * length;
	}
	else
	{
		return v;
	}
}

vector3 capVector(const vector3 &in v, const float length)
{
	if (dp3(v, v) > length * length)
	{
		return normalize(v) * length;
	}
	else
	{
		return v;
	}
}

vector3 min(const vector3 &in a, const vector3 &in b)
{
	return vector3(
		min(a.x, b.x),
		min(a.y, b.y),
		min(a.z, b.z)
	);
}

vector2 min(const vector2 &in a, const vector2 &in b)
{
	return vector2(
		min(a.x, b.x),
		min(a.y, b.y)
	);
}

vector3 max(const vector3 &in a, const vector3 &in b)
{
	return vector3(
		max(a.x, b.x),
		max(a.y, b.y),
		max(a.z, b.z)
	);
}

vector2 max(const vector2 &in a, const vector2 &in b)
{
	return vector2(
		max(a.x, b.x),
		max(a.y, b.y)
	);
}
