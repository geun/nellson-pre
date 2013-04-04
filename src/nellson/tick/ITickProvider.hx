package nellson.tick;

/**
 * ...
 * @author Geun
 */

interface ITickProvider<T> 
{
	public function add(listener:T):Void;
	public function remove(listener:T):Void;
	public function start():Void;
	public function stop():Void;
}