package nellson.quadtree.systems;
import nellson.components.camera.Camera;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoCamera;
import nellson.isometirc.components.IsoSpatial;
import nellson.pathfinding.components.AStarGrid;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.components.controller.MouseController;
import nellson.core.Game;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.statemachine.StateMachine;
import nellson.ds.AABB2;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.Stage;
import nme.errors.Error;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Geun
 */

class QInteractionSystem extends System
{
	private var controller:MouseController;
	private var quadTree:QuadTree<QTreeItemNode>;
	private var camera:IsoCamera;
	private var stage:Stage;
	private var result:QuarryResult;
	private var requestAABB:AABB2;
	private var grid:IGrid;
	
	public function new(quadTree:QuadTree<QTreeItemNode>, camera:IsoCamera, controller:MouseController, grid:IGrid) 
	{
		super();
		
		this.camera = camera;
		this.quadTree = quadTree;
		this.controller = controller;
		this.grid = grid;
		
		stage = Lib.current.stage;
		init();
	}
	
	private function init() 
	{
		result = new QuarryResult();
		requestAABB = new AABB2();
		var view = controller.container;
		view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	
	private function onMouseWheel(e:MouseEvent):Void 
	{
		
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if (controller.isMouseDown) controller.isDraggingMode = true;
		if (controller.isDraggingMode)
		{
			camera.moveCamera(controller.previousPoint.x - stage.mouseX, controller.previousPoint.y - stage.mouseY);
			controller.previousPoint.x = stage.mouseX;
			controller.previousPoint.y = stage.mouseY;
		}
		else
		{
			if (controller.isDesignMode)
			{
				if ( controller.currentSelected != null)
				{
					//선택 되었을때;
					var pos:Point = camera.getIsoPoint(stage.mouseX, stage.mouseY);
					controller.currentSelected.isoSpatial.position.x = pos.x;
					controller.currentSelected.isoSpatial.position.y = pos.y;
					
					controller.currentSelected.isoSpatial.isInvaildationPosition = true;
					controller.currentSelected.isoSpatial.invalidateWalkable = true;
				}
				else
				{
					//선택 되지 않을때
				}
			}
		}
		
		
		
		controller.mouseAABB.centerX = stage.mouseX;
		controller.mouseAABB.centerY = stage.mouseY;
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		
		if (!controller.isDraggingMode && controller.currentSelected == null)
		//if (!controller.isDraggingMode)
		{
			//선택
			detectObject();
		}
		else
		{
			
			if (controller.isDesignMode)
			{
				if (controller.currentSelected != null)
				{
					var invalidateWalkable = controller.currentSelected.isoSpatial.invalidateWalkable;
					if (invalidateWalkable == false) controller.currentSelected = null;
				}	
			}
			//controller.currentSelected = null;
		}
		controller.isDraggingMode = false;
		controller.isMouseDown = false;
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		controller.isMouseDown = true;
		controller.previousPoint.x = stage.mouseX;
		controller.previousPoint.y = stage.mouseY;
	}
	
	override public function update(time:Float):Void 
	{
			
	}
	
	private function detectObject():Void
	{
		var current = camera.getIsoPoint(stage.mouseX, stage.mouseY);
		requestAABB.set(controller.mouseAABB);
		requestAABB.centerX = current.x;
		requestAABB.centerY = current.y;
		
		if ( camera.aabb.contains(requestAABB)) 
		{
			result.reset();
			var num = quadTree.queryAABB(requestAABB, result.data, 100, result.debug );
			//trace(['detect : ', num]);
			
			var pickup = result.sort(false)[0];
			if (pickup != null)
			{
				controller.currentSelected = pickup;
				//controller.mouseClicked.dispatch(pickup, requestAABB);
			}
			else
			{
				trace('아무것도 안선택됨');
				controller.currentSelected = null;
				
			}
		}
		else
		{
			//trace('영역바깥이다.');
		}
		//debug
		
	}
	
	
}