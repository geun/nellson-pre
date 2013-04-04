package nellson.components.camera;
import nellson.isometirc.components.IsoSpatial;
import de.polygonal.core.math.Mathematics;
import nellson.ds.AABB2;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Geun
 */

class Camera 
{
	public var aabb:AABB2; 
	public var offset:Float;
	public var drawPoint:Point;
	public var renderBounds:AABB2;
	public var worldBounds:AABB2;
	public var inValidationSize:Bool;
	
	public var centerAABB:AABB2;
	private var offset2:Float;
	
	public var viewPoint:AABB2; // 카
	
	
	private var cameraOffsetX:Float;
	private var cameraOffsetY:Float;
	
	public var scale(default, setScale):Float;
	public var scaleOffset(default, null):Float;
	public var scaleDirty:Bool;
	
	public var cameraInited:Bool;
	static public inline var RESTIC:Int = 300;
	
	public function new(x:Float, y:Float, width:Float, heigth:Float, offset:Float, worldBounds:AABB2, renderBounds:AABB2) 
	{
		this.aabb = new AABB2(x, y, width, heigth);
		//this.viewPoint = new AABB2(0, 0, 26, 26);
		this.viewPoint = new AABB2(-3, -3, 3, 3);
		
		this.offset = offset;
		this.worldBounds = worldBounds;
		this.renderBounds = renderBounds;
		
		setScale(1.0);
		cameraOffsetX = cameraOffsetY = 0;
		inValidationSize = true;
		inValidatePosition();
		
		cameraInited = false;
	}
	
	private function setScale(value:Float):Float
	{
		scale = value;
		scaleOffset = 1.0 / scale;
		
		scaleDirty = true;
		
		return scale;
	}
	public function inValidatePosition():Void
	{
		//this.aabb.centerX = worldBounds.centerX;
		//this.aabb.centerY = worldBounds.centerY;
		
		viewPoint.centerX = 0;
		viewPoint.centerY = 0;
		//this.aabb.centerX = viewPoint.centerX = 0;
		//this.aabb.centerY = viewPoint.centerY = 0;
		this.centerAABB = this.aabb.clone();
		
		//trace(['worldBounds', worldBounds.intervalX, worldBounds.intervalY]);
		//trace(['center', aabb.centerX, aabb.centerY]);
		
	}
	
	public function getCameraOffsetX():Float
	{
		return camerOffsetX();
	}
	
	public function getCameraOffsetY():Float
	{
		return camerOffsetY();
	}
	
	inline private function camerOffsetX():Float
	{
		return renderBounds.minX - offset  + (renderBounds.intervalX * 0.5);
		//return renderBounds.minX - offset;
	}
	
	inline private function camerOffsetY():Float
	{
		//return renderBounds.minY - offset  + (renderBounds.intervalY * 0.5);
		return renderBounds.minY - offset;
	}
	
	public function moveCamera(x:Float, y:Float, restric:Int = 300):Void
	{
		var offsetX = centerAABB.centerX - aabb.centerX; // 오른쪽으로 갈때 음수
		var offsetY = centerAABB.centerY - aabb.centerY; // 아래로 갈대 음수
		
	
		
		if (aabb.centerX < -aabb.intervalX * .5) aabb.centerX = -aabb.intervalX *.5;
		if (aabb.centerY < -aabb.intervalY * .5) aabb.centerY = -aabb.intervalY * .5;
		if (aabb.centerX > worldBounds.maxX ) aabb.centerX = worldBounds.maxX;
		if (aabb.centerY > worldBounds.maxY ) aabb.centerY = worldBounds.maxY;
		//trace([aabb.centerX ,  aabb.centerY]);
		//trace([offsetX, offsetY]);
		
		/*if ( viewPoint.x < 0 )
		{
			trace('tt');
			cameraOffset = Math.abs(viewPoint.x - 0);
			
		}
		else
		{
			cameraOffset--;
		}*/
		
		viewPoint.centerX += x;
		viewPoint.centerY += y;
		
		if ( viewPoint.centerX > restric ) viewPoint.centerX = restric;
		if ( viewPoint.centerX < -restric ) viewPoint.centerX = -restric;
		if ( viewPoint.centerY > restric ) viewPoint.centerY = restric;
		if ( viewPoint.centerY < -restric ) viewPoint.centerY = -restric;
		//trace([viewPoint.centerX, viewPoint.centerY]);
		
		
		//centerAABB.centerX = aabb.centerX -= x;
		//centerAABB.centerY = aabb.centerY -= y;
		
		//aabb.centerX = viewPoint.centerX;
		//aabb.centerY = viewPoint.centerY;
		
/*		if (aabb.contains(viewPoint))
		{
			aabb.centerX -= x * 1.2;
			aabb.centerY -= y * 1.2; 
		}
		else
		{
			aabb.centerX -= x * .8;
			aabb.centerY -= y * .8; 
		}
		*/
		
	
	}
	
}