package nellson.utils.helper;
import nellson.grid.GridSpatial;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.pathfinding.components.AStarGrid;

/**
 * ...
 * @author Geun
 */

class GridHelper 
{

	public function new() 
	{
		
	}
	
	inline static public function resetPosition(isoTile:IsoTile, grid:IGrid, gridSpatial:GridSpatial, isoSpatial:IsoSpatial, isRotated:Int = 0):Void
	{
		var col = isoTile.col;
		var row = isoTile.row;
		if (isRotated == 0)
		{
			for (offsetX in 0...col)
			{
				for (offsetY in 0...row)
				{
					var x = gridSpatial.x - offsetX;
					var y = gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					grid.setWalkable(x, y, true);
					isoSpatial.invalidateWalkable = false;
				}
			}
		}
		else
		{
			for (offsetX in 0...row)
			{
				for (offsetY in 0...col)
				{
					var x = gridSpatial.x - offsetX;
					var y = gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					grid.setWalkable(x, y, true);
					isoSpatial.invalidateWalkable = false;
				}
			}
		}
	}
	
	inline static public function setPosition(isoTile:IsoTile, grid:IGrid, gridSpatial:GridSpatial, isoSpatial:IsoSpatial, isWalkable:Bool, isRotated:Int = 0):Void
	{
		
		var col = isoTile.col;
		var row = isoTile.row;
		if (isRotated == 0)
		{
			for (offsetX in 0...col)
			{
				for (offsetY in 0...row)
				{
					var x = gridSpatial.x - offsetX;
					var y = gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					grid.setWalkable(x, y, isWalkable);
					isoSpatial.invalidateWalkable = false;
				}
			}
		}
		else
		{
			for (offsetX in 0...row)
			{
				for (offsetY in 0...col)
				{
					var x = gridSpatial.x - offsetX;
					var y = gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					grid.setWalkable(x, y, isWalkable);
					isoSpatial.invalidateWalkable = false;
				}
			}
		}
	}
	
}