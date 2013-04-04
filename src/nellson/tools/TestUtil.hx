package nellson.tools;
import nellson.ds.AABB2;
import nellson.isometirc.components.IsoSpatial;
import nme.display.Shape;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Geun
 */

class TestUtil 
{

	public function new() 
	{
		
	}
	
	public static function findDepth(targetSize:Int, world:AABB2):Int
	{
		var size = Std.int(world.intervalX);
		var depth = 0;
		while( size >= targetSize)
		{
			size >>= 1;
			depth++;
		}
		return depth;
	}
	
	public static function setStage():Stage
	{
		var stage = Lib.current.stage;
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		return stage;
	}
	
	public static function drawPoint(container:Shape, point:Point, offsetX:Float=0, offsetY:Float=0):Void
	{
		container.graphics.lineStyle(0, 0xff0000, 1);
		container.graphics.beginFill(0xff0000, 0.2);
		container.graphics.drawRect(point.x-3 + offsetX, point.y-3+ offsetY, 6,6);
		container.graphics.endFill();
		
	}
	
	public static function drawISOPoint(container:Shape, point:Point, color:Int = 0xff0000, offsetX:Float=0, offsetY:Float=0):Void
	{
		
		var isoP = IsoSpatial.isoToFlat(point.x  , point.y);
		var x = isoP.x + offsetX;
		var y = isoP.y + offsetY;
		
		
		container.graphics.lineStyle(0, color, 1);
		container.graphics.beginFill(color, 0.2);
		container.graphics.drawRect(x-3, y-3, 6,6);
		container.graphics.endFill();
		
	}
	
	public static function drawAABB(container:Shape, aabb:AABB2, fillColor:Bool = false, color:Int = 0xd4d4d4, offsetX:Float = 0, offsetY:Float = 0, thin:Int = 0):Void
	{
		container.graphics.lineStyle(thin, color, 1);
		if (fillColor)	container.graphics.beginFill(color, 0.2);
		container.graphics.drawRect(aabb.minX + offsetX, aabb.minY + offsetY, aabb.intervalX, aabb.intervalY);
		if (fillColor) container.graphics.endFill();
	}
	
	public static function drawISOAABB(container:Shape, aabb:AABB2, fillColor:Bool = false, color:Int = 0xd4d4d4, offsetX:Float = 0, offsetY:Float = 0):Void
	{
		var size = Std.int(aabb.intervalX);
		//trace(size);
		
		var centerDraw = false;
		
		var width = size >> 1;
		var height = size >> 2;
		
		var isoP = IsoSpatial.isoToFlat(aabb.minX * .5  , aabb.minY * .5);
		var x = isoP.x + offsetX;
		var y = isoP.y + offsetY;
		
		container.graphics.lineStyle(0, color, 1);
		if (fillColor)	container.graphics.beginFill(color, 0.2);
		if (centerDraw)
		{
			container.graphics.moveTo( x, y - height);
			container.graphics.lineTo(x + width, y);
			container.graphics.lineTo(x , y + height);
			container.graphics.lineTo(x  - width, y);
			container.graphics.lineTo(x, y - height);
			
		}
		else
		{
			container.graphics.moveTo(x, y);
			container.graphics.lineTo(x + width, y + height);
			container.graphics.lineTo(x, y + height * 2);
			container.graphics.lineTo(x - width, y + height);
			container.graphics.lineTo(x, y);
			
		}
		if (fillColor) container.graphics.endFill();
	}
}