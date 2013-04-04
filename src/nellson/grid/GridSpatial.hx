package nellson.grid;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class GridSpatial
{
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int, y:Int) 
	{
		this.x = x;
		this.y = y;
	}

	//public function equals(toCompare:Point):Bool
	//{
		//return Std.int(toCompare.x) == x && Std.int(toCompare.y) == y;
	//}
	
}