package nellson.utils;

/**
 * ...
 * @author Geun
 */

using Lambda;
class ArrayTools 
{

	public function new() 
	{
		
	}
	
	static public function unique<T>(x:Array<T>, f: T -> T -> Bool):Array<T>
	{
		var r:Array<T> = new Array();
		for (e in x)
		{
		  if (!r.has(e, f))
			  // you can inline exists yourself if you care much about speed. But then you should consider using hash tables or such
			r.push(e);
		 
		}	
		return r;
	}
	
}