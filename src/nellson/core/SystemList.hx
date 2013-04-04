package nellson.core;

/**
 * ...
 * @author Geun
 */

class SystemList 
{

	public var head:System;
	public var tail:System;
	
	
	public function add(system:System):Void
	{
		if (head == null)
		{
			head = tail = system;
			system.next = system.prev = null;
		}
		else
		{
			var node = tail;
			while (node != null)
			{
				if ( node.priority <= system.priority ) break;
				node = node.prev;
			}
			if ( node == tail)
			{
				tail.next = system;
				system.prev = tail;
				system.next = null;
				tail = system;
			}
			else if ( node == null)
			{
				system.next = head;
				system.prev = null;
				head.prev = system;
				head = system;
			}
			else
			{
				// insert system between node and node.next
				system.next = node.next;
				system.prev = node;
				node.next.prev = system;
				node.next = system;
			}
		}
	}
	public function remove(system:System):Void
	{
		if (head == system)
		{
			head = head.next;
		}
		if ( tail == system)
		{
			tail = tail.prev;
		}
		if (system.prev != null)
		{
			system.prev.next = system.next;
		}
		if (system.next != null)
		{
			system.next.prev = system.prev;
		}
		
		// N.B. Don't set system.next and system.previous to null because that will break the list iteration if node is the current node in the iteration.
	}
	
	
	public function get( type:Class<Dynamic>):System
	{
		//TODO: system get 
		
		var system:System = head;
		while ( system != null)
		{
			system = system.next;
		}
		
		return null;
		
		
	}
	public function removeAll(system:System):Void
	{
		
		while ( head != null)
		{
			var system = head;
			head = head.next;
			system.prev = null;
			system.next = null;
		}
		tail = null;
	}
	
	public function new() 
	{
		
	}
	
}