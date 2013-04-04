package nellson.components;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class Motion 
{
	public var velocity:Point;
	public var angularVelocity:Float;
	public var damping:Float;
	public var speed:Float;
	
	public function new(velocityX:Float, velocityY:Float, angularVelocity:Float, damping:Float, speed:Float = 200) 
	{
		velocity = new Point(velocityX, velocityY );
		this.angularVelocity = angularVelocity;
		this.damping = damping;
		this.speed = speed;
	}
	
}