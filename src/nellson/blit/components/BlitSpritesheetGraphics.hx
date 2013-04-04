package nellson.blit.components;
import nellson.blit.components.ITilesheet;
import nellson.ds.AABB2;
import com.touchingsignal.secretgarden.game.model.components.GraphicsOffset;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

enum BlitGraphicsState
{
	UP;
	OVER_NOMAL;
	OVER_GREEN;
	OVER_RED;
	DOWN;
}

class BlitSpritesheetGraphics
{
	public var aabb:AABB2;
	public var registerationPoint:Point;
	public var state:BlitGraphicsState;
	public var offsets:GraphicsOffset;
	public var rotation:Int;

	public function new(aabb:AABB2, registerationPoint:Point, rotation:Int = 0, ?offsets:GraphicsOffset) 
	{
		this.aabb = aabb;
		this.registerationPoint = registerationPoint;
		//this.offsets = offsets;
		this.rotation = rotation;
		
		this.state = BlitGraphicsState.UP;
	}
}