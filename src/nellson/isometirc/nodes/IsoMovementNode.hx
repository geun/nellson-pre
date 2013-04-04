package nellson.isometirc.nodes;
import nellson.components.Motion;
import nellson.core.Node;
import nellson.grid.GridSpatial;
import nellson.isometirc.components.IsoSpatial;
import nellson.pathfinding.components.Destination;
import nellson.ds.AABB2;

/**
 * ...
 * @author Geun
 */

class IsoMovementNode extends Node
{
	public var isoSpatial:IsoSpatial;
	public var aabb:AABB2;
	public var motion:Motion;
	public var destination:Destination;
	public var gridSpatial:GridSpatial;

	public function new() 
	{
		super();
	}
	
}