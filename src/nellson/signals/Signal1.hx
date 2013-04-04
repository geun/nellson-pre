package nellson.signals;

/**
 * ...
 * @author Geun
 */

class Signal1<T> extends SignalBase<T->Void>
{
	var type:Class<T>;
	
	public function new(type:Class<T>) 
	{
		super();
		this.type = type;
	}
	
	public function dispatch(object:T):Void
	{
		startDispatch();
		var node = head;
		while ( node != null)
		{
			node.listener(object);
			node = node.next;
		}
		
		endDispatch();
	}
	
}