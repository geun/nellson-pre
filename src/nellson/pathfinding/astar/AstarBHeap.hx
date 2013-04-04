package nellson.pathfinding.astar;
import nellson.ds.BinaryHeap;
import nellson.pathfinding.components.Path;
import de.polygonal.core.math.Mathematics;
import de.polygonal.ds.Array2;
import de.polygonal.ds.DA;
import de.polygonal.ds.pooling.DynamicObjectPool;
import nme.errors.EOFError;
import nme.errors.Error;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class AstarBHeap 
{
	private var openHeap:BinaryHeap<AstarNode>;
	private var touched:DA<AstarNode>;
	private var grid:Array2<AstarNode>;
	
	public function new(grid:Array2<AstarNode>) 
	{
		touched = new DA();
		this.grid = grid;
		openHeap = new BinaryHeap(function (node:AstarNode):Float { return node.f; } );
	}
	
	public function getEvaluatedTile():DA<AstarNode>
	{
		return touched;
	}
	
	private function reset():Void
	{
		if (touched == null) touched = new DA();
		else for (node in touched) node.reset();
		openHeap.reset();
		touched.clear();
		//touched = new DA();
	}
	
	public function search(start:AstarNode, end:AstarNode, output:Path):Path
	{
		reset();
		output.clear();
		openHeap.push(start);
		
		while (openHeap.size > 0)
		{
			var currentNode  = openHeap.pop();
			if ( currentNode.position.x == end.position.x && currentNode.position.y == end.position.y)
			{
				var current = currentNode;
				var result = output;
				
				//trace(pathPool.size());
				while ( current.parent != null)
				{
					result.pushBack(current);
					current = current.parent;
				}
				result.reverse();
				//result.pushFront(start);
				return result;
			}
			
			//Nomal case
			currentNode.closed = true;
			touched.pushBack(currentNode);
			var neighbors = getNeighbors(grid, currentNode, false);
			for ( neighbor in neighbors)
			{
				if (neighbor.closed || !neighbor.isWalkable) continue;
				
				var gScore = currentNode.g + 1;
				var beenVisited:Bool = neighbor.visited;
				if ( !beenVisited) touched.pushBack(neighbor);
				if (beenVisited == false || gScore < neighbor.g)
				{
					neighbor.visited = true;
					neighbor.parent = currentNode;
					neighbor.h = manhattan(neighbor.position, end.position);
					neighbor.g = gScore;
					neighbor.f = neighbor.g + neighbor.h;
					
					if ( !beenVisited) openHeap.push(neighbor);
					else openHeap.rescoreElement(neighbor);
				}
			}
			
		}
		
		
		return output;
	}
	
	public function getNeighbors(grid:Array2<AstarNode>, node:AstarNode, allowDiagonal:Bool = true):DA<AstarNode>
	{	
		
		var result = new DA<AstarNode>(8);
		var x:Int = Std.int(node.position.x);
		var y:Int = Std.int(node.position.y);
		var gridWidth = grid.getW();
		var gridHeight = grid.getH();
		//var id:Int = 0;
		//trace([x, y, gridWidth, gridHeight]);
		try {
			if ( x > 0)
				result.pushBack(grid.get(x - 1, y)); // left 
			if ( x < gridWidth - 1)
				result.pushBack(grid.get(x + 1, y)); // right
			if (y > 0)
				result.pushBack(grid.get(x, y - 1)); //top 
			if (y < gridHeight -1) 
				result.pushBack(grid.get(x, y + 1)); //bottom
		
			if (allowDiagonal)
			{
				if ( x > 0)
				{
					if ( y > 0 && ( grid.get(x, y - 1).isWalkable || grid.get(x + 1, y).isWalkable))
					{
						//trace('leftTop');
						result.pushBack(grid.get(x - 1, y - 1)); // left top
					}
						
					if ( y < gridHeight - 1 && (grid.get(x - 1, y).isWalkable || grid.get(x, y + 1).isWalkable))
					{
						//trace('left Bottom');
						result.pushBack(grid.get(x - 1, y + 1)); // left bottom
					}
				}
				if ( x < gridWidth - 1) 
				{	
					if ( y > 0 && (grid.get(x, y - 1).isWalkable || grid.get(x + 1, y).isWalkable))
					{
						//trace('right top');
						result.pushBack(grid.get(x + 1, y - 1)); // right top
					}
					if ( y < gridHeight - 1 && (grid.get(x + 1, y).isWalkable || grid.get(x, y + 1).isWalkable))
					{
						//trace(['right bottom',x,y]);
						result.pushBack(grid.get(x + 1, y + 1)); // right bottom
						
					}
				}
				
			}
		}catch (msg:Error)
		{
			result.clear();
		}
		return result;
	}
	
	private function manhattan(p1:Point, p2:Point):Int
	{
		var d1 = Mathematics.abs(Std.int(p2.x - p1.x));
		var d2 = Mathematics.abs(Std.int(p2.y - p1.y));
		
		//var diag = d1 < d2 ? d1 : d2;
		//return Std.int( Mathematics.SQRT2 * diag + d1 +d2 - 2 * diag );
		return d1 + d2;
	}
	
	
}