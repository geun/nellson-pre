package nellson.blit.components;
import nellson.ds.AABB2;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */
enum GraphicsState
{
	UP;
	OVER_NOMAL;
	OVER_GREEN;
	OVER_RED;
	DOWN;
}
 
 
class BlitGraphicsData
{
	public var upBitmapData:BitmapData;
	public var overBitmapData:BitmapData;
	public var tilesheet:ITilesheet;
	
	public var registerationPoint:Point;
	public var aabb:AABB2;
	
	public var state:GraphicsState;
	
	public function new(up:BitmapData, over:BitmapData, tilesheet:ITilesheet, aabb:AABB2, registerationPoint:Point ) 
	{
		this.upBitmapData = up;
		this.overBitmapData = over;
		this.tilesheet = tilesheet;
		this.aabb = aabb;
		this.registerationPoint = registerationPoint;
		
		state = GraphicsState.UP;
		//aabb = new AABB2(0, 0, view.width, view.height);
	}
	
}

