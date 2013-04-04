package nellson.core;

/**
 * ...
 * @author Geun
 */

class NodePool<T>
{
	private var tail:Node;
	private var nodeClass:Class<T>;
	private var cacheTail:Node;
	
	public function new(nodeClass:Class<T>) 
	{
		this.nodeClass = nodeClass;
	}
	
	public function get():Dynamic
	{
		if (tail != null)
		{
			var node:Node = tail;
			tail = tail.prev;
			node.prev = null;
			//trace('reuse node : ' + node);
			return node;
		}
		else
		{
			//return Type.createEmptyInstance(nodeClass);
			//trace('new node');
			return Type.createInstance(nodeClass,[]);
		}
	}
	
	public function dispose(node:Node):Void
	{
		//trace('dispose : ' + node);
		node.next = null;
		node.prev = tail;
		tail = node;
	}
	
	public function cache(node:Node):Void
	{
		node.prev = cacheTail;
		cacheTail = node;
	}
	
	public function releaseCache():Void
	{
		while ( cacheTail != null)
		{
			var node:Node = cacheTail;
			cacheTail = node.prev;
			/*node.next = null;
			node.prev = tail;
			tail = node;*/
			dispose(node);
		}
	}
	
}