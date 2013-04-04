package nellson.signals;

/**
 * ...
 * @author Geun
 */

class Signal0 extends SignalBase<Void->Void>
{

	public function new() 
	{
		super();
	}
	
	public function dispatch():Void
	{
		startDispatch();
		var node = head;
		while ( node != null)
		{
			node.listener();
			node = node.next;
		}
		
		endDispatch();
	}
	
}