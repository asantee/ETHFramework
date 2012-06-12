class SGlobalScale
{
	private float m_absoluteSize;

	SGlobalScale(const float _absoluteSize)
	{
		updateScaleFactor(_absoluteSize);
	}

	/// Checks the current screen dimension to keep scale up-to-date.
	/// Avoids "fake screen sizes" like the one in Android 3.x
	void updateScaleFactor(const float _absoluteSize, const bool fixedHeight = true)
	{
		m_absoluteSize = _absoluteSize;
		if (fixedHeight)
			SetFixedHeight(m_absoluteSize);
		else
			SetFixedWidth(m_absoluteSize);
	}

	float getAbsoluteSize()
	{
		return m_absoluteSize;
	}

	float getScale()
	{
		return GetScale();
	}

	float scale(const float v)
	{
		return Scale(v);
	}

	vector2 scale(const vector2 v)
	{
		return Scale(v);
	}	

	vector3 scale(const vector3 v)
	{
		return Scale(v);
	}	

	void scaleEntity(ETHEntity@ entity)
	{
		float individualScale = 1.0f;
		if (entity.CheckCustomData("scale") != DT_NODATA)
		{
			individualScale = entity.GetFloat("scale");
		}

		entity.Scale(getScale() * individualScale);
		entity.SetPosition(entity.GetPosition() * getScale());
		// multiplyCustomData(entity, "speed");
	}

	collisionBox getAbsoluteCollisionBox(ETHEntity@ entity)
	{
		collisionBox box = entity.GetCollisionBox();
		box.pos *= getScale();
		box.size *= getScale();
		if (entity.GetAngle() != 0.0f)
		{
			matrix4x4 m = rotateZ(degreeToRadian(entity.GetAngle()));
			box.pos = multiply(box.pos, m);
		}
		box.pos += entity.GetPosition();
		return box;
	}

	void multiplyCustomData(ETHEntity@ entity, const string name)
	{
		if (entity.CheckCustomData(name) == DT_FLOAT)
			entity.MultiplyFloat(name, getScale());
	}

	void scaleEntities()
	{
		ScaleEntities();
	}	
}

SGlobalScale g_scale(DEFAULT_SCALE_HEIGHT);
