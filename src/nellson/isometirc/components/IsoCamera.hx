package nellson.isometirc.components;
import nellson.components.camera.Camera;
import nellson.ds.AABB2;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class IsoCamera extends Camera
{
	
	public var computeStageX:Float;
	public var computeStageY:Float;
	
	public function new(x:Float, y:Float, width:Float, heigth:Float, offset:Float, worldBounds:AABB2, renderBounds:AABB2) 
	{
		super(x, y, width, heigth, offset, worldBounds, renderBounds);
	}
	
	
	public function getIsoPoint(x:Float, y:Float):Point
	{
		var cx = x + viewPoint.centerX - getCameraOffsetX();
		var cy = y + viewPoint.centerY - getCameraOffsetY();
		
		var p:Point = IsoSpatial.flatToIso(cx, cy); // iso 커서로 바꿔줌.. 
		//trace(['convert : ', x, y, p.toString(), col, row]);
		return p;
	}
	
	public function getFlatPoint(x:Float, y:Float):Point
	{
		//TODO: 나중에 이것도 인젝트 형식으로 바꾸자 
		var p:Point = IsoSpatial.isoToFlat(x, y);
		var cx = p.x - viewPoint.centerX + getCameraOffsetX();
		var cy = p.y - viewPoint.centerY + getCameraOffsetY();
		
		//trace(['convert : ', x, y, p.toString(), col, row]);
		return new Point(cx, cy);
	}
	
}