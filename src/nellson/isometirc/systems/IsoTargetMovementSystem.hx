package nellson.isometirc.systems;
import nellson.isometirc.nodes.IsoMovementNode;
import nellson.tools.ListIteratingSystem;
import de.polygonal.core.math.Mathematics;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class IsoTargetMovementSystem extends ListIteratingSystem<IsoMovementNode>
{
	public function new() 
	{
		super(IsoMovementNode, updateNode);
	}
	
	private function updateNode(node:IsoMovementNode, time:Float):Void
	{
		if (node.destination.invalidateDestination)
		{
			var p:Point = node.destination.position.subtract(node.isoSpatial.position);
			var deltaX = Mathematics.sgn(Std.int(p.x));
			var deltaY = Mathematics.sgn(Std.int(p.y));
			var speed = node.motion.speed;
			
			node.isoSpatial.position.x += deltaX * speed;
			node.isoSpatial.position.y += deltaY * speed;
			node.isoSpatial.isInvaildationPosition = true;
			
			if (p.length < 1) 
			{
				//trace(['from',node.destination.position.toString(),'to',node.isoSpatial.position.toString()]);
				node.destination.arrived = true;
			}
		}
	}
}