package nellson.quadtree.systems;
import nellson.core.System;
import nellson.isometirc.nodes.IsoMovementNode;
import nellson.tools.ListIteratingSystem;
/**
 * ...
 * @author Geun
 */

class QMotionSystem extends ListIteratingSystem<IsoMovementNode>
{

	public function new() 
	{
		super(IsoMovementNode, updateNode);
	}
	
	private function updateNode(node:IsoMovementNode, time:Float):Void
	{
		
	}
	
	
}