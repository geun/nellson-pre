package nellson.core;

/**
 * ...
 * @author Geun
 */

class EntityList 
{
	public var head:Entity;
	public var tail:Entity;
	
	private var _size:Int;
	public function new() 
	{
		//TODO: need to performance test between this and polygonal dll
	}
	
	public function size():Int
	{
		return _size;
	}
	
	public function add(entity:Entity):Void
	{
		if ( head == null)
		{
			head = tail = entity;
			entity.next = entity.prev = null;
		}
		else
		{
			tail.next = entity;
			entity.prev = tail;
			entity.next = null;
			tail = entity;
		}
		_size++;
	}
	public function remove(entity:Entity):Entity
	{
		
		if (head == entity)
		{
			head = head.next;
		}
		if (tail == entity)
		{
			tail = tail.prev;
		}
		if (entity.prev != null)
		{
			entity.prev.next = entity.next;
		}
		if (entity.next != null)
		{
			entity.next.prev = entity.prev;
		}
		
		// N.B. Don't set node.next and node.previous to null because that will break the list iteration if node is the current node in the iteration.
		
		_size--;
		if (_size < 0) _size = 0;
		return entity;
	}
	
	public function removeAll():Void
	{
		var entity:Entity = head;
		while ( head != null)
		{
			head = head.next;
			entity.prev = null;
			entity.next = null;
		}
		tail = null;
		_size = 0;
	}
	
	
	
}