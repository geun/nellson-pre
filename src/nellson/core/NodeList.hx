package nellson.core;
import nellson.signals.Signal1;
/**
 * ...
 * @author Geun
 */

class NodeList<T:Node>
{
	//Linked List
	public var head:T;
	public var tail:T;
	public var nodeAdded:Signal1<T>;
	public var nodeRemoved:Signal1<T>;
	
	var _size:Int;
	public var nodeClass:Class<T>;
	
	public function new(nodeClass:Class<T>) 
	{
		
		this.nodeClass = nodeClass;
		nodeAdded = new Signal1(nodeClass);
		nodeRemoved = new Signal1(nodeClass);
		_size = 0;
	}
	
	public function add(node:T):Void
	{
		if (head == null)
		{
			head = tail = node;
			node.next = node.prev = null;
		}
		else
		{
			tail.next = node;
			node.prev = tail;
			node.next = null;
			tail = node;
		}
		_size++;
		nodeAdded.dispatch(node);
	}
	public function remove(node:T):Void
	{
		if ( head == node)
		{
			
			head = head.next;
		}
		if ( tail == node)
		{
			tail = tail.prev;
		}
		if ( node.prev != null)
		{
			node.prev.next = node.next;
		}
		if ( node.next != null)
		{
			node.next.prev = node.prev;
		}
		_size--;
		 // N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.
		nodeRemoved.dispatch(node);
	}
	
	public function removeAll():Void
	{
		var node = head;
		while( head != null)
		{
			node.prev = null;
			node.next = null;
			
			node = node.next;
			nodeRemoved.dispatch(node);
		}
		_size = 0;
		if (_size < 0) _size = 0;
		tail = null;
	}
	
	public function empty():Bool
	{
		return size() == 0? true : false;
	}
	
	public function size():Int
	{
		return _size;
	}
	
	/*public function swap( node1 : Node, node2 : Node ):Void
	{
		if( node1.previous == node2 )
		{
			node1.previous = node2.previous;
			node2.previous = node1;
			node2.next = node1.next;
			node1.next  = node2;
		}
		else if( node2.previous == node1 )
		{
			node2.previous = node1.previous;
			node1.previous = node2;
			node1.next = node2.next;
			node2.next  = node1;
		}
		else
		{
			var temp : Node = node1.previous;
			node1.previous = node2.previous;
			node2.previous = temp;
			temp = node1.next;
			node1.next = node2.next;
			node2.next = temp;
		}
		if( head == node1 )
		{
			head = node2;
		}
		else if( head == node2 )
		{
			head = node1;
		}
		if( tail == node1 )
		{
			tail = node2;
		}
		else if( tail == node2 )
		{
			tail = node1;
		}
		if( node1.previous )
		{							
			node1.previous.next = node1;
		}
		if( node2.previous )
		{
			node2.previous.next = node2;
		}
		if( node1.next )
		{
			node1.next.previous = node1;
		}
		if( node2.next )
		{
			node2.next.previous = node2;
		}
	}*/
	
}