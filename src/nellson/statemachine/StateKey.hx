package nellson.statemachine;
import de.polygonal.ds.HashableItem;

/**
 * ...
 * @author Geun
 */

class StateKey extends HashableItem
{
	public var type:String;
	public function new(type:String)
	{
		super();
		this.type = type;
	}
}