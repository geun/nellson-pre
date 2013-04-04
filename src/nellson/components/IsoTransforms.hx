package nellson.components;

/**
 * ...
 * @author Geun
 */

class IsoTransforms extends Transforms
{
	public var isoX:Float;
	public var isoY:Float;
	
	public var sortVal:Float;
	public var sortOffsetY:Float;
	
	//public var isInvalidatedPosition:Bool;
	
	public function new(x:Float, y:Float, rotation:Float, scale:Float, alpha:Float) 
	{
		super(x, y, rotation, scale, alpha);
		
		//isInvalidatedPosition = false;
		
	}
	
}