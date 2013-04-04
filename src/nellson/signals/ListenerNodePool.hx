package nellson.signals;

/**
 * ...
 * @author Geun
 */

class ListenerNodePool 
{
	var tail:ListenerNode;
	var cacheTail:ListenerNode;
	public var counter:Int;
	
	public function get():ListenerNode
	{
		if (tail == null)
		{
			++counter;
			return new ListenerNode();
		}
		else
		{
			var node = tail;
			tail = tail.prev;
			node.prev = null;
			return node;
			
		}
	}
	
	public function dispose(node:ListenerNode):Void
	{
		--counter;
		node.listener = null;
		node.next = null;
		node.prev = tail;
		tail = node;
	}
	
	public function cache(node:ListenerNode):Void
	{
		node.listener = null;
		node.prev = cacheTail;
		cacheTail = node;
	}
	
	public function releaseCache():Void
	{
		while ( cacheTail != null)
		{
			var node = cacheTail;
			cacheTail = node.prev;
			node.next = null;
			node.prev = tail;
			tail = node;
		}
	}
	
	public function new()
	{
		
	}
}