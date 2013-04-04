package nellson.isometirc.systems;

import nellson.components.camera.Camera;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoGrid;
import nellson.isometirc.nodes.IsoMovementNode;
import nellson.tools.ListIteratingSystem;

/**
 * ...
 * @author Geun
 */

class IsoMovementSystem extends ListIteratingSystem<IsoMovementNode>
{
	private var camera:Camera;
	private var grid:IGrid;
	private var maxCol:Float;
	private var maxRow:Float;
	
	public function new(camera:Camera,grid:IGrid) 
	{
		this.grid = grid;
		
		this.camera = camera;
		super(IsoMovementNode, updateNode);
		
		maxCol = grid.getColsNum() * (grid.getSellSize() >> 1);
		maxRow = grid.getRowNum() * (grid.getSellSize() >> 1);
		
		var s:Float = 10;
		var s2:String;
		trace(['Movesystem  ', maxCol, maxRow ]);
		
	}
	
	private function updateNode(node:IsoMovementNode, time:Float):Void
	{
		node.isoSpatial.position.x += node.motion.velocity.x * time;
		node.isoSpatial.position.y += node.motion.velocity.y * time;
		
		//if (node.isoSpatial.position.x > maxCol ) node.isoSpatial.position.x = 0;
		//if (node.isoSpatial.position.x < 0) node.isoSpatial.position.x = maxCol;
		//if (node.isoSpatial.position.y > maxRow) node.isoSpatial.position.y = 0;
		//if (node.isoSpatial.position.y < 0) node.isoSpatial.position.y = maxRow;
		
		node.isoSpatial.isInvaildationPosition = true;
		
	}
	
}