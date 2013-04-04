package nellson.blit.systems;
import nellson.blit.nodes.BlitRenderNode;
import nellson.blit.nodes.SpriteSheetNode;
import nellson.core.System;
import nellson.tools.ListIteratingSystem;

/**
 * ...
 * @author Geun
 */

class SpriteSheetAnimateSystem extends ListIteratingSystem<SpriteSheetNode>
{

	public function new() 
	{
		super(SpriteSheetNode, updateNode);
	}
	
	public function updateNode(node:SpriteSheetNode, time:Float):Void
	{
		//trace('tested' + time);
		node.spriteSheet.update(time);
	}
	
}