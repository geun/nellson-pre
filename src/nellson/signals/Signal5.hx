package nellson.signals;

/**
 * ...
 * @author Geun
 */

class Signal5 < T1, T2, T3, T4, T5 > extends SignalBase < T1->T2->T3->T4->T5->Void >
{

	var type1:Class<T1>;
	var type2:Class<T2>;
	var type3:Class<T3>;
	var type4:Class<T4>;
	var type5:Class<T4>;
	
	public function new(type1:Class<T1>, type2:Class<T2>, type3:Class<T3>, type4:Class<T4>, type5:Class<T5>) 
	{
		super();
		this.type1 = type1;
		this.type2 = type2;
		this.type3 = type3;
		this.type4 = type4;
		this.type5 = type5;
	}
	
	public function dispatch(val1:T1, val2:T2, val3:T3, val4:T4, val5:T5):Void
	{
		startDispatch();
		var node = head;
		while (node != null)
		{
			node.listener(val1, val2, val3, val4, val5);
			node = node.next;
		}
		
		endDispatch();
	}
	
}