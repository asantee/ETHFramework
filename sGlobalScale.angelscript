class sGlobalScale
{
	private float m_scaleFactor;
	private float m_absoluteSize;

	sGlobalScale(const float _absoluteSize)
	{
		m_absoluteSize = _absoluteSize;
		updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	}

	/// Checks the current screen dimension to keep scale up-to-date.
	/// Avoids "fake screen sizes" like the one in Android 3.x
	void updateScaleFactor(const float _absoluteSize)
	{
		m_absoluteSize = _absoluteSize;
		m_scaleFactor = GetScreenSize().y / m_absoluteSize;
	}

	float getAbsoluteSize()
	{
		return m_absoluteSize;
	}

	float getScale()
	{
		return m_scaleFactor;
	}

	float scale(const float v)
	{
		return m_scaleFactor * v;
	}

	vector2 scale(const vector2 v)
	{
		return m_scaleFactor * v;
	}	

	vector3 scale(const vector3 v)
	{
		return m_scaleFactor * v;
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
		multiplyCustomData(entity, "speed");
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
		ETHEntityArray entities;
		GetAllEntitiesInScene(entities);
		for (uint t=0; t<entities.size(); t++)
		{
			if (entities[t].CheckCustomData("scalable") == DT_NODATA || entities[t].GetUInt("scalable") != 0)
			{
				scaleEntity(entities[t]);
			}
			if (entities[t].CheckCustomData("hidden") != DT_NODATA)
			{
				entities[t].Hide(true);
			}
		}
	}	
}

sGlobalScale g_scale(480);
