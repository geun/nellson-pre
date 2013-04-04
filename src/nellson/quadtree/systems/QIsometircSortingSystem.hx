package nellson.quadtree.systems;


import nellson.core.Game;
import nellson.core.NodeList;
import nellson.core.System;
import nellson.quadtree.components.QuarryResult;
import nme.Lib;
/**
 * ...
 * @author Geun
 */

class QIsometircSortingSystem extends System
{
	private var renderNodes:QuarryResult;

	public function new(renderNodes:QuarryResult) 
	{
		super();
		this.renderNodes = renderNodes;
		
	}
	
	override public function addToGame(game:Game):Void 
	{
		//nodeList = game.getNodeList( IsospatialNode );
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		//nodeList = null;
	}
	
	override public function update(time:Float):Void 
	{
		//trace('update');
		//var t = Lib.getTimer();
		renderNodes.sort(true);
		//var result = Lib.getTimer() - t;
		//trace('time : ' + result);
	}
	
}