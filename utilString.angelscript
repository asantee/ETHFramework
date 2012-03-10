string vector3ToString(const vector3 &in v3)
{
	return "(" + v3.x + ", " + v3.y + ", " + v3.z + ")";
}

string vector2ToString(const vector2 &in v2)
{
	return "(" + v2.x + ", " + v2.y + ")";
}

string[] splitString(string str, const string c)
{
	string[] v;
	uint pos;
	while ((pos = str.find(c)) != NPOS)
	{
		v.insertLast(str.substr(0, pos));
		str = str.substr(pos + c.length(), NPOS);
	}
	v.insertLast(str);
	return v;
}

bool equalsAny(const string &in a, string[]@ values)
{
	const uint n = values.length();
	for (uint t = 0; t < n; t++)
	{
		if (a == values[t])
			return true;
	}
	return false;
}
