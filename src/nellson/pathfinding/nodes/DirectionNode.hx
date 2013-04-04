package nellson.pathfinding.nodes;
import nellson.blit.components.BlitSpritesheet;
import nellson.core.Node;
import nellson.pathfinding.components.Directions;

/**
 * ...
 * @author Geun
 */

class DirectionNode extends Node
{
	public var directions:Directions;
	public var blitSpritesheet:BlitSpritesheet;
	
	public function new() 
	{
		super();
	}
	
}