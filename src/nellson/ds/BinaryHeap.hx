package nellson.ds;
import nellson.pathfinding.astar.AstarNode;
import de.polygonal.ds.DA;

/**
 * ...
 * @author Geun
 */

 
class BinaryHeap<T:IHeapable>
{
	private var content(default, null):DA<T>;
	private var scoreFunction:T-> Float;
	
	public function new(scoreFunction:T-> Float ) 
	{
		content = new DA<T>();
		this.scoreFunction = scoreFunction;
	}
	
	public function reset():Void
	{
		content = new DA<T>();
	}
	
	public function push(node:T):Void
	{
		content.pushBack(node);
		sinkDown(content.size() - 1);
	}
	
	
	public function pop():T
	{
		var result = content.get(0);
		var end = content.popBack();
		
		if ( content.size() > 0)
		{
			content.set(0, end);
			bubbleUp(0);
		}
		return result;
	}

	public function remove(node:T):Void
	{
		var i = content.indexOf(node);
		var end = content.popBack();
		if ( i != content.size() - 1)
		{
			content.set(i , end);
			if (scoreFunction(end) < scoreFunction(node)) sinkDown(i);
			else bubbleUp(i);
			
		}
		
	}
	
	public var size(getSize, null):Int;
	private function getSize():Int
	{
		return content.size();
	}
	
	public function rescoreElement(node:T):Void
	{
		sinkDown(content.indexOf(node));
	}
	private function sinkDown(n:Int):Void 
	{
		var node = content.get(n);
		
		while (n > 0)
		{
			var parentIdx = content.indexOf(node.parent);
			if ( parentIdx == -1 ) parentIdx = 0;
			
			var parent = content.get(parentIdx);
			
			if ( scoreFunction(node) < scoreFunction(parent))
			{
				content.set(parentIdx, node);
				content.set(n, parent);
				n = parentIdx;
			}
			else
			{
				break;
			}
		}
	}
	
	private function bubbleUp(n:Int):Void
	{
		var length = content.size();
		var node = content.get(n);
		var nodeScore = scoreFunction(node);
		
		while (true)
		{
			var child2Idx = (n + 1) << 1;
			var child1Idx = child2Idx - 1;
			
			var child1Score = 0.0;
			
			var swap:Dynamic = null;
			if ( child2Idx < length)
			{
				var child1 = content.get(child1Idx);
				child1Score = scoreFunction(child1);
				
				if ( child1Score < nodeScore) swap = child1Idx;
			}
			
			if ( child2Idx < length)
			{
				var child2 = content.get(child2Idx);
				var child2Score = scoreFunction(child2);
				if ( child2Score < (swap == null ? nodeScore : child1Score))
				{
					swap = child2Idx;
				}
			}
			
			if (swap != null)
			{
				content.set(n, content.get(swap));
				content.set(swap, node);
				n = swap;
			}
			
			else
			{
				break;
			}
			
		}
	}
	
}