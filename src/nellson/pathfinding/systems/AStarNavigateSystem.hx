package nellson.pathfinding.systems;

import nellson.core.Game;
import nellson.grid.IGrid;
import nellson.pathfinding.astar.AstarBHeap;
import nellson.pathfinding.astar.AstarNode;
import nellson.pathfinding.components.AStarGrid;
import nellson.pathfinding.components.Directions;
import nellson.pathfinding.components.Path;
import nellson.pathfinding.nodes.AStarNavigateNode;
import nellson.tools.ListIteratingSystem;
import de.polygonal.core.math.Mathematics;
import de.polygonal.ds.Array2;
import de.polygonal.ds.DA;
import de.polygonal.ds.pooling.DynamicObjectPool;
import de.polygonal.ds.pooling.ObjectPool;
import nme.geom.Point;
/**
 * ...
 * @author Geun
 */

class AStarNavigateSystem extends ListIteratingSystem<AStarNavigateNode>
{
	private var astar:AstarBHeap;
	private var halfSize:Int;
	private var cellSize:Int;
	
	private var grid:AStarGrid;
	private var aStarNodes:Array2<AstarNode>;
	private var colsNum:Int;
	private var rowsNum:Int;
	
	private var pointPool:ObjectPool<Point>;

	public function new(grid:AStarGrid)
	{
		this.grid = grid;
		this.aStarNodes = cast grid.getData(); 
		
		super(AStarNavigateNode, updateNodes, addNode);
		astar = new AstarBHeap(aStarNodes);
		
		cellSize = grid.getSellSize();
		halfSize = cellSize >> 1;
		this.colsNum = grid.getColsNum();
		this.rowsNum = grid.getRowNum();
		
		pointPool = new ObjectPool(100);
		pointPool.allocate(false, Point);
	}
	
	private function addNode(node:AStarNavigateNode):Void 
	{
		trace('set');
		var start = aStarNodes.get(node.gridSpatial.x, node.gridSpatial.y);
		//start.isWalkable = false;
	}
	
	override public function addToGame(game:Game):Void 
	{
		super.addToGame(game);
		nodeList.nodeAdded.add(findWay);
	}
	override public function removeFromGame(game:Game):Void 
	{
		super.removeFromGame(game);
	}
	
	private function updateNodes(node:AStarNavigateNode, time:Float):Void
	{
		
		if ( node.path.size() > 0)
		{
			debug(node);
			var nextKey = pointPool.next();
			var currentKey = pointPool.next();
			
			var nextPoint:Point = pointPool.get(nextKey);
			var currentPos:Point = pointPool.get(currentKey);
			//var destination:AstarNode = node.path.get(0);
			var destination = node.destination.node;
			if ( destination.isWalkable == false)
			{
				node.destination.invalidateDestination = false;
				//current position is start poisition
				var c = grid.computeGridPosition(node.isoSpatial.position.x, node.isoSpatial.position.y);
				node.gridSpatial.x = c.x;
				node.gridSpatial.y = c.y;
				//return;
				findWay(node);
				//node.path.clear();
			}
			
			var first:Point = destination.position;
			
			nextPoint.x = first.x * halfSize;
			nextPoint.y = first.y * halfSize;
			currentPos.x = node.isoSpatial.position.x;
			currentPos.y = node.isoSpatial.position.y;
			
			var distance:Float = Point.distance(currentPos , nextPoint);
			var max  = node.motion.speed * 5;
			
			if ( distance <= max) // 해당 위치에 왔을때?
			{
				var path:DA<AstarNode> = node.path;
				//trace(destination.isWalkable);
				var next:AstarNode = path.popFront(); // 다음 웨이포인트를 가지고옴.
				node.gridSpatial.x = Std.int(next.position.x);
				node.gridSpatial.y = Std.int(next.position.y);
				if (node.path.size() == 0)
				{
					node.isoSpatial.position.x = next.position.x * halfSize;
					node.isoSpatial.position.y = next.position.y * halfSize;
					
					next.isWalkable = false;
					//zeroVelocity(node);
				}
				else
				{
					//setVelocity(node);
					
				}
				
				setDestination(node);
			}
			
			pointPool.put(nextKey);
			pointPool.put(currentKey);
		}
		else
		{
			findWay(node);
		}
		
	}
	
	
	inline private function findWay(node:AStarNavigateNode):Void
	{
		//trace('find way');
		var start = aStarNodes.get(node.gridSpatial.x, node.gridSpatial.y);
		var p = getRandomPoisiton();
		while (	true )
		{
			//trace('re');
			if ( start.position.x == p.x && start.position.y == p.y)
			{
				p = getRandomPoisiton();
				continue;
			}
			else if ( aStarNodes.get(p.x,p.y).isWalkable == false)
			{
				p = getRandomPoisiton();
				continue;
			}
			break;
		}
		
		var end = aStarNodes.get(p.x, p.y);
		var path = astar.search(start, end, node.path);
		if (path.size() != 0)
		{
			node.path = path;
			start.isWalkable = true;
			setDestination(node);
		}
	}
	
	private function getRandomPoisiton(): { x:Int, y:Int }
	{
		var dx = Std.int(Math.random() * grid.getColsNum());
		var dy = Std.int(Math.random() * grid.getRowNum());
		
		return { x: dx, y: dy };
	}
	
	inline private function debug(node:AStarNavigateNode):Void
	{
		for (node in node.path)
		{
			node.debug = true;
		}
	}
	private function zeroVelocity(node:AStarNavigateNode):Void
	{
		node.motion.velocity.x = 0;
		node.motion.velocity.y = 0;
	}
	
	private  inline function setDestination(node:AStarNavigateNode):Void
	{
		if (node.path.size() > 0 )
		{
			
			var first:AstarNode =  node.path.get(0);
			var dx = first.position.x * halfSize;
			var dy = first.position.y * halfSize;
			
			node.destination.setNode(first, halfSize);
			//
			//node.destination.position.x = dx;
			//node.destination.position.y = dy;
			var direction = node.direction.direction;
			var nextDirection = getDirection(Std.int(first.position.x), Std.int(first.position.y), node.gridSpatial.x, node.gridSpatial.y);
			
			if(direction != nextDirection)	node.direction.direction = nextDirection;
 
			//node.destination.node = first;
			//node.destination.position.normalize(100);
			//node.destination.position = node.path.get(0).position;
			//node.destination.invalidateDestination = true;
		}
	}
	
	private function setVelocity(node:AStarNavigateNode):Void
	{
		if (node.path.size() > 0 )
		{
			var speed = node.motion.speed;
			var desKey = pointPool.next();
			var moveKey = pointPool.next();
			
			var destination:Point = pointPool.get(desKey);
			var moveVector:Point = pointPool.get(moveKey);
			var first:Point =  node.path.get(0).position;
			destination.x = first.x * halfSize;
			destination.y = first.y * halfSize;
			
			moveVector.x = destination.x -  node.isoSpatial.position.x;
			moveVector.y = destination.y -  node.isoSpatial.position.y;
			
			moveVector.normalize(1);
			node.motion.velocity.x = moveVector.x * speed;
			node.motion.velocity.y = moveVector.y * speed;
			
			pointPool.put(desKey);
			pointPool.put(moveKey);
		
		}
	}
	
	
	private function getDirection(x:Int, y:Int, cx:Int, cy:Int):String
	{
		if (x > cx && y > cy)
			{
				return Directions.S;
			}
			else if (x > cx && y < cy)
			{
				return Directions.E;
			}
			else if (x > cx && y == cy)
			{
				return Directions.SE;
			}
			else if (x == cx && y > cy)
			{
				return Directions.SW;
			}
			else if (x == cx && y < cy)
			{
				return Directions.NE;
			}
			else if (x < cx && y > cy)
			{
				return Directions.W;
			}
			else if (x < cx && y < cy)
			{
				return Directions.N;
			}
			else if (x < cx && y == cy)
			{
				return Directions.NW;
			}
			else
			{
				return '';
			}
			
	}	
	
}