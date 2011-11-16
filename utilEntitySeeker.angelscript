/// Creates an array containing every entity within thisEntity's bucket and the buckets around it, including itself
void getSurroundingEntities(ETHEntity @thisEntity, ETHEntityArray @outEntities)
{
	const vector2 bucket(thisEntity.GetCurrentBucket());
	GetEntitiesFromBucket(bucket, outEntities);
	GetEntitiesFromBucket(bucket+vector2(1, 0), outEntities);
	GetEntitiesFromBucket(bucket+vector2(1, 1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(0, 1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1, 1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1, 0), outEntities);
	GetEntitiesFromBucket(bucket+vector2(-1, -1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(0, -1), outEntities);
	GetEntitiesFromBucket(bucket+vector2(1, -1), outEntities);
}

/// Finds an entity named 'entityName' among all thisEntity's surrounding entities.
ETHEntity @findAmongNeighbourEntities(ETHEntity @thisEntity, const string &in entityName)
{
	ETHEntityArray entityArray;
	getSurroundingEntities(thisEntity, entityArray);
	uint size = entityArray.size();
	for (uint t=0; t<size; t++)
	{
		if (entityArray[t].GetEntityName() == entityName)
		{
			return @entityArray[t];
		}
	}
	return null;
}

/// Finds all entities named 'entityName' among all thisEntity's surrounding entities.
void findAllAmongNeighbourEntities(ETHEntity @thisEntity, const string &in entityName, ETHEntityArray @outEntities)
{
	ETHEntityArray entityArray;
	getSurroundingEntities(thisEntity, entityArray);
	uint size = entityArray.size();
	for (uint t=0; t<size; t++)
	{
		if (entityArray[t].GetEntityName() == entityName)
		{
			ETHEntity@ temp = entityArray[t];
			outEntities.push_back(temp);
		}
	}
}

/// Scans the screen for an entity named 'name' and returns a handle to it if found.
ETHEntity @findEntityInScreen(const string &in name)
{
	ETHEntityArray entities;
	GetVisibleEntities(entities);
	for (uint t=0; t<entities.size(); t++)
	{
		if (entities[t].GetEntityName() == name)
		{
			return entities[t];
		}
	}
	return null;
}

void getEntitiesFromNeighbourBuckets(const vector2 &in centerBucket, uint count, ETHEntityArray@ targets)
{
	int _count = int(count);
	for (int i = _count * -1; i <= _count; i++)
	{
		for (int k = _count * -1; k <= _count; k++)
		{
			GetEntitiesFromBucket(vector2(centerBucket.x - i, centerBucket.y - k), targets);
		}
	}	
}

interface EntityChooser
{
	bool choose(ETHEntity@ entity);
}
class DefaultChooser : EntityChooser { bool choose(ETHEntity@ entity) { return true; } }
class DynamicChooser : EntityChooser { bool choose(ETHEntity@ entity) { return !entity.IsStatic(); } }
DefaultChooser g_defaultChooser;
DynamicChooser g_dynamicChooser;

ETHEntity@ seekNeighbourEntity(const vector2 &in centerBucket, const string &in entityName, EntityChooser@ chooser = @g_defaultChooser)
{
	ETHEntityArray ents;
	for (int i = -1; i <= 1; i++)
	{
		for (int k = -1; k <= 1; k++)
		{
			GetEntitiesFromBucket(vector2(centerBucket.x - i, centerBucket.y - k), ents);
			for (uint t = 0; t < ents.size(); t++)
			{
				if (ents[t].GetEntityName() == entityName && chooser.choose(@ents[t]))
				{
					return ents[t];
				}
			}
			ents.clear();
		}
	}
	return null;
}

ETHEntity@ seekEntity(const string &in entityName, EntityChooser@ chooser = @g_defaultChooser)
{
	ETHEntityArray ents;
	GetAllEntitiesInScene(ents);
	for (uint t = 0; t < ents.size(); t++)
	{
		if (ents[t].GetEntityName() == entityName && chooser.choose(@ents[t]))
		{
			return ents[t];
		}
	}
	return null;
}

ETHEntity@ seekEntityFromBucket(const vector2 &in bucket, const int entityID)
{
	ETHEntityArray ents;
	GetEntitiesFromBucket(bucket, ents);
	for (uint t = 0; t < ents.size(); t++)
	{
		if (ents[t].GetID() == entityID)
		{
			return ents[t];
		}
	}
	return null;
}

ETHEntity@ chooseClosestContact(const vector2 &in a, const vector2 &in b, EntityChooser@ chooser)
{
	ETHEntityArray entities;
	float squaredDist = squaredDistance(a, b);
	GetContactEntities(a, b, entities);
	ETHEntity@ r = null;
	for (uint t = 0; t < entities.size(); t++)
	{
		if (chooser.choose(entities[t]))
		{
			const float currentDistance = squaredDistance(a, entities[t].GetPositionXY());
			if (currentDistance < squaredDist)
			{
				@r = @(entities[t]);
				squaredDist = currentDistance;
			}
		}
	}
	return r;
}
