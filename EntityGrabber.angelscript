funcdef bool GRAB_VALIDATE(ETHEntity@ entity);

class EntityGrabber
{
	private ETHEntityArray m_entities;

	EntityGrabber(const vector2 &in point, const float radius, GRAB_VALIDATE@ validate)
	{
		ETHEntityArray ents;
		getEntitiesFromNeighbourBuckets(GetBucket(point), 1, ents);
		for (uint t = 0; t < ents.size(); t++)
		{
			if (!validate(@ents[t]))
				continue;

			ETHPhysicsController@ sim = ents[t].GetPhysicsController();
			if (sim is null)
				continue;

			if (sim.GetShape() == BS_CIRCLE)
			{
				const float radiusSum = (ents[t].GetCollisionBox().size.x * g_scale.scale(0.5f)) + radius;
				if (squaredDistance(ents[t].GetPositionXY(), point) < radiusSum * radiusSum)
				{
					ETHEntity@ temp = ents[t];
					m_entities.push_back(temp);
				}
			}
			else
			{
				const vector3 collisionSize = ents[t].GetCollisionBox().size * g_scale.getScale();
				Shape shape(ents[t].GetPositionXY(), vector2(collisionSize.x, collisionSize.y), ents[t].GetAngle(), true);
				if (shape.overlapSphere(point, radius))
				{
					ETHEntity@ temp = ents[t];
					m_entities.push_back(temp);
				}
			}
		}
	}

	uint size() const
	{
		return m_entities.size();
	}

	ETHEntity@ get(const uint t)
	{
		return m_entities[t];
	}
}
