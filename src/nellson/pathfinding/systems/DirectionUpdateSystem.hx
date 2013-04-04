package nellson.pathfinding.systems;
import nellson.pathfinding.components.Directions;
import nellson.pathfinding.nodes.DirectionNode;
import nellson.tools.ListIteratingSystem;

/**
 * ...
 * @author Geun
 */

class DirectionUpdateSystem extends ListIteratingSystem<DirectionNode>
{

	public function new() 
	{
		super(DirectionNode, updateNode, addNode, removeNode);
	}
	
	public function addNode(node:DirectionNode):Void
	{
		/*var isoSpatial:IsoSpatial = node.effect.linkedEntity.get(IsoSpatial);
		//var aabb:AABB2 = node.popicon.linkedEntity.get(AABB2);
		
		var blitSpritesheet:BlitSpritesheet = node.effect.linkedEntity.get(BlitSpritesheet);
		var offsetX = blitSpritesheet.getFrameRect().width * .5;
		var offsetY = blitSpritesheet.getFrameRect().height * .5;
		
		#if flash
		node.isoSpatial.position.x = isoSpatial.position.x - offsetX;
		#else
		//node.isoSpatial.position.x = isoSpatial.position.x - aabb.intervalX;
		node.isoSpatial.position.x = isoSpatial.position.x - offsetX;
		//node.isoSpatial.position.x = isoSpatial.position.x - (aabb.intervalX * .25);
		#end
		
		//node.isoSpatial.position.x = isoSpatial.position.x - 120;
		node.isoSpatial.position.y = isoSpatial.position.y - offsetY - 15;*/
		//node.blitSpritesheet.play();
		//node.blitSpritesheet.updateCycle(Directions.SE);
		
		node.directions.setDirection(Directions.SE);
	}
	public function removeNode(node:DirectionNode):Void
	{
		
	}
	
	public function updateNode(node:DirectionNode, time:Float):Void
	{
		//trace('update');
		//node.blitSpritesheet.update(time);
		
		if (node.directions.invalidateDirection)
		{
			
			node.blitSpritesheet.updateCycle(node.directions.direction);
			node.directions.invalidateDirection = false;
		}
	}
}