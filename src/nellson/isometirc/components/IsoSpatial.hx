package nellson.isometirc.components;
import nellson.ds.AABB2;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class IsoSpatial 
{
	
	public var position:Point;
	//public var isoX(getIsoX, setIsoX):Float; 
	//public var isoY(getIsoY, setIsoY):Float;
	public var zIndex(default, null):Float;
	public var isInvaildationPosition:Bool;
	public var invalidateWalkable:Bool;
	
	public var setAble:Bool;
	
	public function new(isoX:Float , isoY:Float)
	{
		position = new Point(isoX, isoY);
		isInvaildationPosition = true;
		invalidateWalkable = true;
		setAble = false;
		
		update();
	}
	
	
	
	inline public function isoToFlatX():Float
	{
		return (position.x - position.y);
	}
	inline public function isoToFlatY():Float
	{
		return cast Std.int( position.x + position.y) >> 1;
	}
	
	inline static public function isoToFlat(isoX:Float, isoY:Float):Point
	{
		
		return new Point(isoX - isoY, Std.int(( isoX + isoY)) >> 1);
	}
	
	inline static public function isoToFlatToPoint(p:Point, isoX:Float, isoY:Float):Void
	{
		p.x = isoX - isoY;
		p.y = Std.int(( isoX + isoY)) >> 1;
		//return new Point(isoX - isoY, Std.int(( isoX + isoY)) >> 1);
	}
	
	inline static public function isoToFlatAABB(isoAABB:AABB2):AABB2
	{
		var minPoint = isoToFlat(isoAABB.minX, isoAABB.minY);
		var maxPoint = isoToFlat(isoAABB.maxX, isoAABB.maxY);
		
		return new AABB2(minPoint.x, minPoint.y, maxPoint.x, maxPoint.y);
	}
	
	inline static public function flatToIsoAABB(flatAABB:AABB2):AABB2
	{
		var minPoint = isoToFlat(flatAABB.minX, flatAABB.minY);
		var maxPoint = isoToFlat(flatAABB.maxX, flatAABB.maxY);
		
		return new AABB2(minPoint.x, minPoint.y, maxPoint.x, maxPoint.y);
	}
	
	inline static public function flatToIso(x:Float, y:Float, cameraX:Float=0, cameraY:Float=0, zoom:Float=1):Point
	{
		var screenX:Float = x / zoom + cameraX;
		var screenY:Float = y / zoom + cameraY;
		return new Point(y + ( Std.int(x) >> 1), ( Std.int(~x + 1) >> 1) + y);
	}
	
	inline static public function flatToIsoToPoint(p:Point, x:Float, y:Float, cameraX:Float=0, cameraY:Float=0, zoom:Float=1):Void
	{
		var screenX:Float = x / zoom + cameraX;
		var screenY:Float = y / zoom + cameraY;
		
		p.x = y + ( Std.int(x) >> 1);
		p.y = ( Std.int(~x + 1) >> 1) + y;
	}
	
	public function update():Void
	{
		//trace('  isoToFlat : ' + isoToFlatX() + ' / ' + isoToFlatY());
		zIndex = (Std.int(isoToFlatY()) << 17 ) + isoToFlatX();
	}
	
}