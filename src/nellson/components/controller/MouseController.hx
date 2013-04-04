package nellson.components.controller;
import nellson.blit.components.BlitGraphicsData;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.core.Entity;
import nellson.ds.AABB2;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.signals.Signal1;
import nellson.signals.Signal2;
import nme.display.DisplayObjectContainer;
import nme.events.MouseEvent;
import nme.geom.Point;

import msignal.Signal;
/**
 * ...
 * @author Geun
 */

class MouseController implements IController
{
	
	public var container:DisplayObjectContainer;
	public var mouseEnable:Bool;
	
	public var isMouseMove:Bool;
	public var isMouseDown:Bool;
	public var isMouseUp:Bool;
	public var isDraging:Bool;
	
	public var isDesignMode:Bool;
	public var isDraggingMode:Bool; // 마우스가 움직일때
	
	//public var isObjectMove(default, null):Bool;
	
	public var currentMousePoint:Point;
	public var previousPoint:Point;
	
	public var mouseAABB:AABB2;
	public var dragingObject:QTreeItemNode;
	
	public var mouseClicked:Signal2<QTreeItemNode, AABB2>;
	
	public var currentSelected(default, updateCurrentSelected):Entity;
	public var prevSelected:Entity;
	
	
	public var currentOvered(default, updateCurrentOvered):Entity;
	public var prevOvered:Entity;
	
	public var updateSelected:Signal0;
	
	//public var scale:Float;
	
	public function new(container:DisplayObjectContainer, mouseSize:Int = 64  ) 
	{
		this.container = container;
		mouseClicked = new Signal2(QTreeItemNode, AABB2);
		
		mouseEnable = true;
		
		currentMousePoint = new Point();
		previousPoint = new Point();
		
		updateSelected = new Signal0();
		
		prevSelected = null;
		prevOvered = null;
		//scale = 1;
		isDesignMode = false;
		var size = mouseSize >> 1;
		mouseAABB = new AABB2(-size, -size, size, size);
	}
	
	private function updateCurrentSelected(node:Entity):Entity
	{
		prevSelected = currentSelected;
		currentSelected = node;
		
		updateSelected.dispatch();
		
		return currentSelected;
	}
	private function updateCurrentOvered(node:Entity):Entity
	{
		prevOvered = currentOvered;
		currentOvered = node;
		return currentOvered;
	}
	
	
	//inline private function retrieveEntity(node:QTreeItemNode):Entity
	//{
		//
	//}
	

} 