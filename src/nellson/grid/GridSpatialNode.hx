package nellson.grid;
import nellson.blit.components.BlitGraphicsData;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.components.Info;
import nellson.core.Node;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;

/**
 * ...
 * @author Geun
 */

class GridSpatialNode extends Node
{
	public var info:Info;
	public var gridSpatial:GridSpatial;
	public var isoSpatial:IsoSpatial;
	public var isoTile:IsoTile;
	public var graphicsData:BlitSpritesheetGraphics;
	
	public function new() 
	{
		super();
	}
	
}