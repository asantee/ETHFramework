void blinkColor(ETHEntity@ thisEntity, const vector3 &in colorA, const vector3 &in colorB, const uint stride = 300)
{
	if (thisEntity.CheckCustomData("blinkElapsedTime") == DT_NODATA)
	{
		thisEntity.SetUInt("blinkElapsedTime", 0);
	}

	thisEntity.AddToUInt("blinkElapsedTime", g_timeManager.getLastFrameElapsedTime());
	const uint elapsedTime = thisEntity.GetUInt("blinkElapsedTime");

	const bool invert = (((elapsedTime / stride) % 2) == 1);
	float bias = float(elapsedTime % stride) / float(stride);
	bias = invert ? 1.0f - bias : bias;
	const vector3 color(interpolate(colorA, colorB, bias));

	thisEntity.SetColor(color);
}

void blinkEmissive(ETHEntity@ thisEntity, const vector3 &in colorA, const vector3 &in colorB, const uint stride = 300)
{
	if (thisEntity.CheckCustomData("blinkElapsedTime") == DT_NODATA)
	{
		thisEntity.SetUInt("blinkElapsedTime", 0);
	}

	thisEntity.AddToUInt("blinkElapsedTime", g_timeManager.getLastFrameElapsedTime());
	const uint elapsedTime = thisEntity.GetUInt("blinkElapsedTime");

	const bool invert = (((elapsedTime / stride) % 2) == 1);
	float bias = float(elapsedTime % stride) / float(stride);
	bias = invert ? 1.0f - bias : bias;
	const vector3 color(interpolate(colorA, colorB, bias));

	thisEntity.SetEmissiveColor(color);
}

/*
Requires two properties:
float stide
float speed
*/
void linearMotion(ETHEntity@ thisEntity, const bool vertical, const float angle = 0.0f)
{
	if (thisEntity.CheckCustomData("originalPos") == DT_NODATA)
	{
		thisEntity.SetVector3("originalPos", thisEntity.GetPosition());
		thisEntity.SetFloat("angle", 0);
	}

	const float speed = thisEntity.GetFloat("speed") / g_scale.getScale();
	thisEntity.AddToFloat("angle", g_timeManager.unitsPerSecond(speed));
	if (thisEntity.GetFloat("angle") > PI * 2)
	{
		thisEntity.AddToFloat("angle",-PI * 2);
	}

	const float stride = thisEntity.GetFloat("stride");
	const float offset = cos(thisEntity.GetFloat("angle")) * stride * sign(speed);

	matrix4x4 m = rotateZ(degreeToRadian(angle));
	const vector3 offsetV3 = multiply((vertical) ? vector3(0, offset, 0) : vector3(offset, 0, 0), m);

	thisEntity.SetPosition(thisEntity.GetVector3("originalPos") + (offsetV3 * g_scale.getScale()));
}
