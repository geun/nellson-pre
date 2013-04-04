package nellson.isometirc.systems;
import nellson.components.camera.Camera;
import nellson.core.Game;
import nellson.core.NodeList;
import nellson.core.System;
import nellson.grid.GridSpatialNode;
import nellson.isometirc.nodes.IsoSpatialNode;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;

/**
 * ...
 * @author Geun
 */

class IsoGridRenderSystem extends System
{
	@inject
	public var container:DisplayObjectContainer;
	
	private var gridView:Shape;
	private var gridNodeList:NodeList<Dynamic>;
	private var camera:Camera;
	
	
	public function new(camera:Camera) 
	{
		super();
		this.camera = camera;
	}
	
	override public function addToGame(game:Game):Void 
	{
		super.addToGame(game);
		
		gridNodeList = game.getNodeList(IsoSpatialNode);
		
		var root:Sprite = cast container.getChildByName('gridLayer');
		gridView = new Shape();
		gridView.name = 'gridShape';
		root.addChild(gridView);
		
		
	}
	override public function removeFromGame(game:Game):Void 
	{
		super.removeFromGame(game);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		gridView.graphics.clear();
		var node:IsoSpatialNode = gridNodeList.head;
		while (node != null)
		{
			updateNode(node, time);
			node = node.next;
		}
		
	}
	
	private function updateNode(node:IsoSpatialNode, time:Float):Void
	{
		if (node.isoTile.isDrawing)
		{
			drawTile(node);
		}
	}
	
	
	inline private function drawTile(node:IsoSpatialNode, ?fillColor:Int, ?isState:Bool):Void
	{
		//var x = node.col * halfSize;
		//var y = node.row * halfSize;
		
		var cameraOffsetX = camera.getCameraOffsetX();
		var cameraOffsetY = camera.getCameraOffsetY();
		
		var renderX = node.isoSpatial.isoToFlatX()- camera.viewPoint.centerX + cameraOffsetX;
		var renderY = node.isoSpatial.isoToFlatY() - camera.viewPoint.centerY + cameraOffsetY;
		
		
		//trace('draw tile');
		
		var rotation = false;
		if ( node.blitSpritesheetGraphics.rotation == 1) rotation = true;
		node.isoTile.draw(gridView, renderX, renderY, true, true, rotation);
		//debugDraw(x, y, halfSize, halfSize);
	}
	
	inline private function isoToFlatX(x:Float, y:Float):Float
	{
		return (x - y);
	}
	inline private function isoToFlatY(x:Float, y:Float):Float
	{
		return cast ( x + y) >> 1;
	}
	
}