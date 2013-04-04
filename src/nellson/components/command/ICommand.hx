package nellson.components.command;
import nellson.core.Entity;

/**
 * ...
 * @author Geun
 */

interface ICommand 
{
	function excute(entity:Entity):Bool;
}