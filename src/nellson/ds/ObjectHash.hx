package nellson.ds;
import de.polygonal.ds.IntHashTable;

/**
 * ...
 * @author Geun
 */

 #if flash
 import flash.utils.TypedDictionary;
 #end
 
 
class ObjectHash<T>
{
	#if flash
	private var dictionary:TypedDictionary<Dynamic, T>;
	#else
	private var hash:IntHashTable<T>;
	#end
	
	
	private static var nextObjectID:Int = 0;
	
	
	public function new() 
	{
		#if flash
		dictionary = new TypedDictionary<Dynamic, T> ();
		#else
		hash = new IntHashTable<T>(512);
		#end
		
		
	}
	
	public inline function keys():Dynamic
	{
		#if flash
		return dictionary.keys();
		#else
		return hash.keys();
		#end
		
		
	}
	
	
	public inline function size():Int
	{
		#if flash
		var count:Int = 0;
		var iter = dictionary.iterator();
		
		while (iter.hasNext())
		{
			iter.next();
			count++;
		}
		return count;
		#else
		return hash.size();
		#end
	}
	
	public inline function has(key:Dynamic):Bool
	{
		#if flash
		return dictionary.exists(key);
		#else
		return hash.hasKey(getID(key));
		
		#end
	}
	
	#if cpp 
	private inline function hasKey(key:Int):Bool
	{
		return hash.hasKey(key);
	}
	#end
	public inline function get(key:Dynamic):T
	{
		#if flash
		return dictionary.get(key);
		#else
		//trace(key);
		return hash.get(getID(key));
		#end
	}
	
	private function getID(key:Dynamic):Int
	{
		#if cpp
		//trace(key);
		//trace(untyped __global__.__hxcpp_obj_id (key));
		return untyped __global__.__hxcpp_obj_id (key);
		#else
		if (key.___id___ == null)
		{
			key.___id___ = nextObjectID ++;
			if (nextObjectID == 2147483647)
			{
				nextObjectID = 0;
			}
		}
		return key.___id___;
		#else
		return 0;
		#end
	}
	
	public inline function iterator():Iterator<T>
	{
		#if flash
		var values:Array <T> = new Array <T> ();
		for (key in dictionary.iterator ()) {
			values.push (dictionary.get (key));
		}
		return values.iterator();
		#else
		return hash.iterator();
		#end
	}
	
	public inline function remove(key:Dynamic):Void
	{
		#if flash
		dictionary.delete (key);
		#else
		hash.clr(getID(key));
		#end
	}
	
	/*
	 * 플래쉬는 이전데이터를 덮어쓰기하지만 
	 * cpp는 기존 것 뒤에 이어붙이기 형태라 앞에것을 먼저 remove 시킨후 
	 * 새 데이터를 set 해야함
	*/
	
	public inline function set(key:Dynamic, value:T):Void
	{
		#if flash
		dictionary.set(key, value);
		#else
		var id:Int = cast getID(key);
		//trace([id, key, value]);
		if (hash.hasKey(id)) hash.clr(id);
		hash.set(id, value);
		#end
	}
}