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

void bounce(ETHEntity@ thisEntity, const vector2 &in scaleA, const vector2 &in scaleB, const uint stride = 300)
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
	const vector2 scale(interpolate(scaleA, scaleB, smoothEnd(bias)));

	thisEntity.SetScale(g_scale.scale(scale));
}

/*
Requires two properties:
float stide
float speed
*/
void linearMotion(ETHEntity@ thisEntity, const bool vertical, const float angle = 0.0f, const float startAngle = 0.0f)
{
	if (thisEntity.CheckCustomData("originalPos") == DT_NODATA)
	{
		thisEntity.SetVector3("originalPos", thisEntity.GetPosition());
		thisEntity.SetFloat("angle", startAngle);
	}

	const float speed = thisEntity.GetFloat("speed");
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

void followUp(ETHEntity@ thisEntity, const vector2 destPos, const uint interpStride = 600, const uint updateRate = 100, const bool dontPause = true)
{
	if (thisEntity.CheckCustomData("switchTime") == DT_NODATA)
	{
		PositionInterpolator@ interp = PositionInterpolator(thisEntity.GetPositionXY(), destPos, interpStride, dontPause);
		@(interp.m_filter) = @smoothEnd;
		thisEntity.SetObject("interp", @interp);
		thisEntity.SetUInt("switchTime", 0);
	}
	PositionInterpolator@ interp;
	thisEntity.GetObject("interp", @interp);
	if (thisEntity.GetPositionXY() != destPos && thisEntity.GetUInt("switchTime") > updateRate)
	{
		interp.reset(interp.getCurrentPos(), destPos, interpStride);
		thisEntity.SetUInt("switchTime", 0);
	}
	thisEntity.AddToUInt("switchTime", (dontPause) ? GetLastFrameElapsedTime() : g_timeManager.getLastFrameElapsedTime());
	interp.update();
	thisEntity.SetPositionXY(interp.getCurrentPos());
}

void scaleToSize(ETHEntity@ entity, const vector2 &in size)
{
	const vector2 currentSize(entity.GetSize());
	entity.Scale(vector2(size.x / currentSize.x, size.y / currentSize.y));
}

void addProjectileEntity(const string &in name, const vector3 &in pos, const vector2 &in dir, const float speed, const float scaleValue)
{
	ETHEntity@ entity;
	AddEntity(name, pos, @entity);
	entity.Scale(scaleValue);
	entity.SetVector2("direction", normalize(dir));
	entity.SetFloat("speed", speed * scaleValue);
}

void projectileBehaviour(ETHEntity@ thisEntity)
{
	const vector2 dir(thisEntity.GetVector2("direction"));
	thisEntity.SetAngle(radianToDegree(getAngle(dir)));
	thisEntity.AddToPositionXY(g_timeManager.unitsPerSecond(dir * thisEntity.GetFloat("speed")));
}
