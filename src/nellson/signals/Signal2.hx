package nellson.signals;

/**
 * ...
 * @author Geun
 */

class Signal2<T1, T2> extends SignalBase<T1->T2->Void>
{
	var type1:Class<T1>;
	var type2:Class<T2>;
	
	public function new(type1:Class<T1>, type2:Class<T2>)
	{
		super();
		this.type1 = type1;
		this.type2 = type2;
	}
	
	public function dispatch(val1:T1, val2:T2):Void
	{
		startDispatch();
		var node = head;
		while ( node != null)
		{
			node.listener(val1, val2);
			node = node.next;
		}
		endDispatch();
	}
	
}