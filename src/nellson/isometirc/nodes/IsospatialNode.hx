package nellson.isometirc.nodes;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.core.Node;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.ds.AABB2;


/**
 * ...
 * @author Geun
 */

class IsoSpatialNode extends Node
{
	public var isoTile:IsoTile;
	public var isoSpatial:IsoSpatial;
	public var aabb:AABB2;
	public var blitSpritesheetGraphics:BlitSpritesheetGraphics;
	
	public function new() 
	{
		super();
	}
	
}