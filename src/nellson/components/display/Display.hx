package nellson.components.display;
import nellson.ds.AABB2;
import nme.display.DisplayObject;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class Display 
{
	public var registerationPoint:Point;
	public var view:DisplayObject;
	public var aabb:AABB2;
	
	public function new(view:DisplayObject, registerationPoint:Point)
	{
		this.view = view;
		this.registerationPoint = registerationPoint;
		
		aabb = new AABB2(0, 0, view.width, view.height);
		
	}
	
}