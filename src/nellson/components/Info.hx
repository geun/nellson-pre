package nellson.components;

/**
 * ...
 * @author Geun
 */

enum InfoType
{
	EventDecos;
	Deco;
	Flowers;
	Building;
	Charactor;
	Popicon;
	Effects;
	DropItems;
	
}
 
 
class Info 
{
	public var name:String;
	public var id:Int;
	public var type:InfoType;
	
	public function new(type:InfoType, name:String) 
	{
		this.type = type;
		this.name = name;
	}
	
}