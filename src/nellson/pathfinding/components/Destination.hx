package nellson.pathfinding.components;
import nellson.pathfinding.astar.AstarNode;
import nellson.signals.Signal1;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class Destination 
{
	public var position:Point;
	/*public var grid:Point;*/
	public var node:AstarNode;
	public var invalidateDestination:Bool;
	public var arrival:Signal1<AstarNode>;
	public var arrived:Bool;
	
	
	public function new() 
	{
		invalidateDestination = false;
		position = new Point(0, 0);
		/*grid = new Point();*/
		node = null;
		arrival = new Signal1(AstarNode);
		arrived = false;
	}
	
	public function setNode(target:AstarNode, size:Int):Void
	{
		if ( this.node != null)  this.node = null;
		/*grid = target.position;*/
		position.x = target.position.x  * size;
		position.y = target.position.y  * size;
		node = target;
		invalidateDestination = true;
	}
	
	public function reset():Void
	{
		position.x = 0;
		position.y = 0;
		node = null;
		invalidateDestination = false;
	}
	
	public function dispathArrival():Void
	{
		
		arrival.dispatch(node);
	}

	
}