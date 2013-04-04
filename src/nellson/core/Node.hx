package nellson.core;
import haxe.rtti.Infos;
/**
 * ...
 * @author Geun
 */

//@:build(MyMacro.rtti()) class Node
class Node //implements Infos
{
	public var entity:Entity;
	public var prev:Dynamic;
	public var next:Dynamic;
	
	public function new() 
	{
		
	}
	
}