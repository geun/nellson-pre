package nellson.pathfinding.components;
import nellson.grid.IGrid;
import nellson.pathfinding.astar.AstarNode;
import de.polygonal.core.math.Mathematics;
import de.polygonal.ds.Array2;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */
 
class AStarGrid implements IGrid
{
	private var sellSize:Int;
	private var halfSize:Int;
	
	private var showGrid:Bool;
	
	private var colsNum:Int;	
	private var rowsNum:Int;
	private var aStarNodes:Array2<AstarNode>;
	
	public function new(cols:Int, rows:Int, size:Int) 
	{
		sellSize = size;
		halfSize = sellSize >> 1;
		
		colsNum = cols;
		rowsNum = rows;
		
		aStarNodes = initNodesForAstar(cols, rows);
		
		//resetWalkable(true);
		
		showGrid = false;
	}
	
	public function getNode(x:Int, y:Int):AstarNode
	{
		return aStarNodes.get(x, y);
	}
	
	public function getData():Dynamic
	{
		return aStarNodes;
	}
	
	inline private function initNodesForAstar(c:Int, r:Int):Array2<AstarNode>
	{
		var nodes:Array2<AstarNode> = new Array2<AstarNode>(c, r);
		var x:Int = 0;
		var y:Int = 0;
		
		for ( x in 0...c)
		{
			for (z in 0...r)
			{
				//var tile = grid.get(x, z);
				var node:AstarNode = new AstarNode();
				node.reset();
				node.isWalkable = true;
				node.position = new Point(x, z);
				nodes.set(x, z, node);
			}
		}
		
		return nodes;
	}
		
	public function getSellSize():Int
	{
		return sellSize;
	}
	public function getColsNum():Int
	{
		return colsNum;
	}
	public function getRowNum():Int
	{
		return rowsNum;
	}
	public function setDisplayGrid(value:Bool):Void
	{
		showGrid = value;
	}
	
	public function getDisplayGrid():Bool
	{
		return showGrid;
	}
	
	public function resetWalkable(value:Bool):Void
	{
		for (node in aStarNodes)
		{
			node.isWalkable = value;
		}
	}
	inline public function getWalkable(x:Int, y:Int):Bool
	{
		return aStarNodes.get(x, y).isWalkable;
	}
	public function setWalkable(x:Int, y:Int, value:Bool):Void
	{
		aStarNodes.get(x, y).isWalkable = value;
	}
	
	public function getDebugPath(x:Int, y:Int):Bool
	{
		return aStarNodes.get(x, y).debug;
	}
	
	public function setDebugPath(x:Int, y:Int, value:Bool):Void
	{
		aStarNodes.get(x, y).debug = value;
	}
	
	inline public function computeGridPosition(x:Float, y:Float):GridPoint
	{
		
		var col = Mathematics.floor(x / halfSize);
		var row = Mathematics.floor(y / halfSize);
		
		return { x:col, y:row} ; 
	}
	
	//public function rotation():Int
	//{
		//
		//
	//}
	
	public function checkGridRotation(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool
	{
		var limitX = x - col +1;
		var limitY = y - row +1;
		if ( x > colsNum || y > rowsNum ||  limitX < 0 ||  limitY < 0) return false;
			
		//if (x < 0 || y < 0) false;
		//if (x > colsNum || y > rowsNum) false;
		
		if (col == row) return true;
		if (rotation == 1)
		{
			var swap = 0;	
			swap = col;
			col = row;
			row = swap;
		}
		
		for ( ix in 0...col)
		{
			for (iy in 0...row)
			{
				//var tile = grid.get(x, z);
				if (ix == 0 && iy == 0) continue;
				var check = getWalkable(x - ix, y - iy);
				if (!check) return false;
			}
		}
		return true;
	}
	
	public function checkGridPosition(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool
	{
		var limitX = x - col +1;
		var limitY = y - row +1;
		if ( x > colsNum || y > rowsNum ||  limitX < 0 ||  limitY < 0) return false;
			
		//if (x < 0 || y < 0) false;
		//if (x > colsNum || y > rowsNum) false;
		
		if (rotation == 1)
		{
			var swap = 0;	
			swap = col;
			col = row;
			row = swap;
		}
		
		for ( ix in 0...col)
		{
			for (iy in 0...row)
			{
				//var tile = grid.get(x, z);

				var check = getWalkable(x - ix, y - iy);
				if (check == false) return false;
			}
		}
		return true;
	}
	
}