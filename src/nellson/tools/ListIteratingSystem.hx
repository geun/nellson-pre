package nellson.tools;
import nellson.core.Game;
import nellson.core.Node;
import nellson.core.NodeList;
import nellson.core.System;

/**
 * ...
 * @author Geun
 */

class ListIteratingSystem<T:Node> extends System
{
	public var nodeList:NodeList<Dynamic>;
	public var nodeClass:Class<Dynamic>;
	var nodeUpdateFunction:T -> Float -> Void;
	var nodeAddedFunction:T -> Void;
	var nodeRemovedFunction:T -> Void;
	
	public function new(nodeClass:Class<Dynamic>, nodeUpdateFunciton:T -> Float -> Void, ?nodeAddedFunction:T ->  Void, ?nodeRemovedFunction: T->  Void) 
	{	
		super();
		
		this.nodeClass = nodeClass;
		this.nodeUpdateFunction = nodeUpdateFunciton;
		
		if (nodeAddedFunction != null) this.nodeAddedFunction = nodeAddedFunction;
		if (nodeRemovedFunction != null) this.nodeRemovedFunction = nodeRemovedFunction;
	}
	
	override public function addToGame(game:Game):Void 
	{
		//trace('nodeClass : ' + nodeClass);
		nodeList = game.getNodeList( nodeClass );
		if (nodeAddedFunction != null)
		{
			var node:T = nodeList.head;
			while ( node != null)
			{
				nodeAddedFunction(node);
				node = node.next;
			}
			nodeList.nodeAdded.add( nodeAddedFunction );
		}
		if (nodeRemovedFunction != null)
		{
			
			nodeList.nodeRemoved.add( nodeRemovedFunction );
		}
		
	}
	override public function removeFromGame(game:Game):Void 
	{
	
		if ( nodeAddedFunction != null )
		{
			nodeList.nodeAdded.remove( nodeAddedFunction );
			
		}
		if ( nodeRemovedFunction != null )
		{
			nodeList.nodeRemoved.remove( nodeRemovedFunction );
		}
		nodeList = null;
	}
	override public function update(time:Float):Void 
	{
		var node:T = nodeList.head;
		//trace(nodeList.size());
		while (node != null)
		{
			nodeUpdateFunction(node, time);
			node = node.next;
		}
	}
}