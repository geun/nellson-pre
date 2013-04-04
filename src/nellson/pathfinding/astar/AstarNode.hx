package nellson.pathfinding.astar;
import nellson.ds.IHeapable;
import de.polygonal.ds.DA;
import haxe.rtti.Generic;
import nme.geom.Point;


using de.polygonal.ds.ArrayUtil;
/**
 * ...
 * @author Geun
 */

class AstarNode implements IHeapable,  implements Generic
{
	
	public var h:Int;
	public var f:Int;
	public var g:Int;
	
	public var cost:Int;
	public var visited:Bool;
	public var closed:Bool;
	public var isWalkable:Bool;
	public var position:Point;
	public var parent:Dynamic;
	//public var next:AstarNode;
	
	public var debug:Bool;

	public function new() 
	{
		this.position = new Point(0, 0);
		reset();
	}
	
	public function reset():Void
	{
		h = 0;
		g = 0;
		f = 0;
		closed = false;
		visited = false;
		parent = null;
		//next = null;
		debug = false;
	}
	
}