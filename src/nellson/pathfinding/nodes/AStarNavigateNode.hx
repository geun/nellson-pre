package nellson.pathfinding.nodes;
import nellson.components.Motion;
import nellson.core.Node;
import nellson.grid.GridSpatial;
import nellson.isometirc.components.IsoSpatial;
import nellson.pathfinding.components.Destination;
import nellson.pathfinding.components.Directions;
import nellson.pathfinding.components.Path;

/**
 * ...
 * @author Geun
 */

class AStarNavigateNode extends Node
{
	public var path:Path;
	public var motion:Motion;
	public var isoSpatial:IsoSpatial;
	public var gridSpatial:GridSpatial;
	public var destination:Destination;
	public var direction:Directions;
	
	
	public function new() 
	{
		super();
	}
	
}