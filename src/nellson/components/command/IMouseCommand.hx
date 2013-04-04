package nellson.components.command;
import nellson.core.Entity;

/**
 * ...
 * @author Geun
 */

interface IMouseCommand 
{
	function mouseClicked(entity:Entity):Void;
	function mouseMove(entity:Entity):Void;
	function mouseDragStart(entity:Entity):Void;
	function mouseDragEnd(entity:Entity):Void;
	function mouseRollOver(entity:Entity):Void;
	function mouseRollOut(entity:Entity):Void;
	
	function setSelected(entity:Entity):Void;
	function disSelected(entity:Entity):Void;
	
}