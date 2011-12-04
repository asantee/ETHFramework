class FloatColor
{
	FloatColor(const vector3 &in color)
	{
		a = 1.0f;
		r = color.x;
		g = color.y;
		b = color.z;
	}
	FloatColor(const float _a, const vector3 &in color)
	{
		a = _a;
		r = color.x;
		g = color.y;
		b = color.z;
	}
	FloatColor(uint color)
	{
		uint _a, _r, _g, _b;
		_a = (0xFF000000 & color) >> 24;
		_r = (0x00FF0000 & color) >> 16;
		_g = (0x0000FF00 & color) >> 8;
		_b = (0x000000FF & color);
		a = float(_a) / 255.0f;
		r = float(_r) / 255.0f;
		g = float(_g) / 255.0f;
		b = float(_b) / 255.0f;
	}
	void setColor(const vector3 &in color)
	{
		r = color.x;
		g = color.y;
		b = color.z;
	}
	vector3 getVector3() const
	{
		return vector3(r, g, b);
	}
	float getAlpha() const
	{
		return a;
	}
	uint getUInt() const
	{
		return ARGB(uint(a * 255.0f), uint(r * 255.0f), uint(g * 255.0f), uint(b * 255.0f));
	}
	FloatColor opMul(FloatColor color)
	{
		return FloatColor(color.a * a, vector3(color.r * r, color.g * g, color.b *b));
	}
	float a;
	float r;
	float g;
	float b;
}
