package nellson.components;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 * 
 * 위치와 각도, 크기에 대한 정보를 담는 컴포넌트
 * 
 * 
 */

class Transforms
{
	public var position:Point;
	public var rotation:Float;
	public var scale:Float;
	public var alpha:Float;
	
	
	public function new(x:Float, y:Float, rotation:Float = 0, scale:Float = 1, alpha:Float = 1) 
	{
		this.position = new Point(x, y);
		this.rotation = rotation;
		this.scale = scale;
		this.alpha = alpha;
	}
	
}