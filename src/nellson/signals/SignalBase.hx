package nellson.signals;

/**
 * ...
 * @author geun
 */

//import nellson.ds.ObjectHash;
import nellson.ds.modify.ObjectHash;
import de.polygonal.ds.HashTable;
import de.polygonal.ds.IntHashTable;
 
class SignalBase<T>
{
	var head:ListenerNode;
	var tail:ListenerNode;
		
	var listenerNodePool:ListenerNodePool;
	var nodes:ObjectHash<T, ListenerNode>;
	
	var toAddHead:ListenerNode;
	var toAddTail:ListenerNode;
	var dispatching:Bool;
	
	
	public function new() 
	{
		nodes = new ObjectHash<T, ListenerNode>();
		listenerNodePool = new ListenerNodePool();
	}
	
	public function getNum():Int
	{
		return nodes.size();
	}
	
	function startDispatch()
	{
		dispatching = true;
	}

	function endDispatch()
	{
		dispatching = false;
		if ( toAddHead != null )
		{
			if ( head == null)
			{
				head = toAddHead;
				tail = toAddTail;
			}
			else
			{
				tail.next = toAddHead;
				toAddHead.prev = tail;
				tail = toAddTail;
			}
			toAddHead = null;
			toAddTail = null;
		}
		listenerNodePool.releaseCache();
	}
	
	public function add(listener:T):Void
	{
		if ( nodes.has(listener))
		{
			return;
		}
		var node:ListenerNode  = listenerNodePool.get();
		node.listener = listener;
		nodes.set(listener, node);
		
		if (dispatching)
		{
			if (toAddHead == null)
			{
				toAddHead = toAddTail = node;
			}
			else
			{
				toAddTail.next = node;
				node.prev = toAddTail;
				toAddTail = node;
				
			}
		}
		else
		{
			if (head == null)
			{
				head = tail = node;
			}
			else
			{
				tail.next = node;
				node.prev = tail;
				tail = node;
			}
		}
	}
	
	public function remove( listener : T):Void
	{
		//var node:ListenerNode = search(listener);
		var node:ListenerNode = nodes.get(listener);
		if (node != null)
		{
			if (head == node)
			{
				head = head.next;
			}
			if (tail == node)
			{
				tail = tail.prev;
			}
			if (toAddHead == node)
			{
				toAddHead = toAddHead.next;
			}
			if (toAddTail == node)
			{
				toAddTail = toAddTail.prev;
			}
			if ( node.prev != null)
			{
				node.prev.next = node.next;
			}
			if ( node.next != null)
			{
				node.next.prev = node.prev;
			}
			nodes.remove(listener);
			//nodes.remove(node);
			if (dispatching)
			{
				listenerNodePool.cache(node);
			}
			else
			{
				listenerNodePool.dispose(node);
			}
			
		}
	}
	
	public function removeAll():Void
	{
		while (head != null)
		{
			var listener:ListenerNode = head;
			head = head.next;
			listener.prev = null;
			listener.next = null;
		}
		tail = null;
		toAddHead = null;
		toAddTail = null;
	}
	
	inline private function search(val:T):ListenerNode
	{
		var node = null;
		for ( i in nodes)
		{
			if (i.listener == val)
			{
				node = i;
			}
		}
		return node;
	}
	
	
}