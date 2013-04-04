package nellson.pathfinding.components;
import nellson.pathfinding.astar.AstarNode;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class Route 
{
	private var start:Waypoint;
	private var end:Waypoint;
	public var head:Waypoint;
	
	public var length(default, null):Int;
	
	public function new(start:AstarNode, end:AstarNode) 
	{
		this.start = new Waypoint();
		this.end = new Waypoint();
		init(start, end);
	}
	
	private function init(s:AstarNode, e:AstarNode):Void
	{
		start.node = s;
		end.node = e;
		
		start.next = end;
		head = start;
		length = 2;
	}
	
	public function add(node:Waypoint):Void
	{
		if (head == end)
		{
			node.next = head;
			head = node;
		}
		else
		{
			node.next = head.next;
			head.next = node;
		}
		length++;
		
	}
	
	public function pop():Waypoint
	{
		if ( head != null)
		{
			var result = head;
			head = head.next;
			length--;
			return result;
		}
		else
		{
			return null;
		}
		
		
	}
}