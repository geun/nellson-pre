package nellson.quadtree.systems;
import nellson.components.camera.Camera;
import nellson.components.controller.MouseController;
import nellson.core.Game;
import nellson.core.System;
import nellson.isometirc.components.IsoCamera;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.ds.AABB2;
import nellson.tools.TestUtil;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class QMouseDebugSystem extends System
{
	private var controller:MouseController;
	private var container:DisplayObjectContainer;

	private var debugView:Shape;
	private var clickedView:Shape;
	private var camera:IsoCamera;
	private var requestAABB:AABB2;
	
	public function new(container:DisplayObjectContainer, controller:MouseController, camera:IsoCamera) 
	{
		super();
		this.container = container;
		this.controller = controller;
		this.camera = camera;
		debugView = new Shape();
		clickedView = new Shape();
		requestAABB = new AABB2();
	}
	
	override public function addToGame(game:Game):Void 
	{
		container.addChild(debugView);
		container.addChild(clickedView);
		controller.mouseClicked.add(clickedDraw);
	}
	
	private function clickedDraw(node:QTreeItemNode, requestAABB:AABB2):Void
	{
		clickedView.graphics.clear();
		TestUtil.drawAABB(clickedView, requestAABB, false, 0xff0000, 1000, 300, 2);
		
		if (node != null)
		{
			//trace(['pickuped ', node.info.name, node.info.id]);
			TestUtil.drawAABB(clickedView, node.aabb, false, 0xff0000, 1000, 300, 2);
		}
	}
	override public function removeFromGame(game:Game):Void 
	{
		container.removeChild(debugView);
	}
	
	override public function update(time:Float):Void 
	{
		debugView.graphics.clear();
		
		var current:Point = camera.getIsoPoint(controller.currentMousePoint.x, controller.currentMousePoint.y);
		requestAABB.set(controller.mouseAABB);
		requestAABB.centerX = current.x;
		requestAABB.centerY = current.y;
		TestUtil.drawAABB(debugView, requestAABB, false, 0xff0000, 1000, 300);
		TestUtil.drawAABB(debugView, controller.mouseAABB, false, 0xff0000);
		TestUtil.drawISOAABB(debugView, controller.mouseAABB, false, 0xff0000, 1000, 300);
	}
	

	
}