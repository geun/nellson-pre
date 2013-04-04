package nellson.blit.nodes;
import nellson.blit.components.BlitGraphicsData;
import nellson.blit.components.SpriteSheet;
import nellson.components.Transforms;
import nellson.core.Node;
import nme.display.Tilesheet;

/**
 * ...
 * @author Geun
 */

class BlitRenderNode extends Node
{
	public var graphicsData:BlitGraphicsData;
	public var spriteSheet:SpriteSheet;
	public var transforms:Transforms;
	
	public function new() 
	{
		super();
	}
	
}