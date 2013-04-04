package nellson.pathfinding.components;

/**
 * ...
 * @author Geun
 */

class Directions 
{
	public inline static var N:String = "N";
	public inline static var E:String = "E";
	public inline static var W:String = "W";
	public inline static var S:String = "S";
	
	public inline static var NE:String = "NE";
	public inline static var NW:String = "NW";
	
	public inline static var SE:String = "SE";
	public inline static var SW:String = "SW";	
	
	public var direction(default, setDirection):String;
	public var invalidateDirection:Bool;
	
	public function new(?direction:String) 
	{
		this.direction = direction;
		//invalidateDirection = false;
	}
	
	public function setDirection(value:String):String
	{
		//trace(value);
		direction = value;
		invalidateDirection = true;
		
		return direction;
	}
	
}