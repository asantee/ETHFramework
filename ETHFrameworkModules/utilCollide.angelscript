bool collide(ETHEntity@ e1, EntityChooser@ chooser = @g_defaultChooser, uint bucketCount = 1)
{
	return collide(g_scale.getAbsoluteCollisionBox(e1), chooser, bucketCount);
}

bool collide(collisionBox box, EntityChooser@ chooser = @g_defaultChooser, uint bucketCount = 1)
{
	vector2 currentBucket = GetBucket(vector2(box.pos.x, box.pos.y));
	ETHEntityArray entities;
	getEntitiesFromNeighbourBuckets(currentBucket, bucketCount, entities);
	
	for (uint t = 0; t < entities.size(); t++)
	{
		if (entities[t].Collidable())
		{
			if (chooser.choose(entities[t]))
			{
				if (scaledCollide(box, @entities[t]))
				{
					return true;
				}
			}
		}
	}
	return false;
}

bool scaledCollide(ETHEntity@ e1, ETHEntity@ e2)
{
	return scaledCollide(g_scale.getAbsoluteCollisionBox(e1), e2);
}

bool scaledCollide(const collisionBox box, ETHEntity@ e2)
{
	collisionBox c2 = g_scale.getAbsoluteCollisionBox(e2);
	
	if (box.pos.x + box.size.x / 2 <= c2.pos.x - c2.size.x / 2) return false; 
	if (box.pos.y + box.size.y / 2 <= c2.pos.y - c2.size.y / 2) return false;

	if (c2.pos.x + c2.size.x / 2 <= box.pos.x - box.size.x / 2) return false; 
	if (c2.pos.y + c2.size.y / 2 <= box.pos.y - box.size.y / 2) return false;
	return true;
}
