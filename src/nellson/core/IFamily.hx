package nellson.core;
import de.polygonal.ds.Hashable;
import nellson.core.Entity;
import nellson.core.NodeList;

/**
 * ...
 * @author Geun
 */

interface IFamily 
{
	//public var prev:IFamily;
	//public var next:IFamily;	
	
	function get_nodeList():NodeList;
	
	function newEntity(entity:Entity);
	function removeEntity(entity:Entity);
	function componentAddedToEntity(entity:Entity, componentClass:Dynamic):Void
	function componentRemoveFromEntity(entity:Entity, componentClass:Dynamic):Void
	
	function cleanup():Void;
}