package nellson.quadtree.systems;
import nellson.components.controller.MouseController;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoCamera;
import nellson.quadtree.nodes.QTreeItemNode;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.display.Stage;
import nme.events.MouseEvent;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.Lib;
import org.gestouch.core.GestureState;
import org.gestouch.core.IGestureDelegate;
import org.gestouch.core.Touch;
import org.gestouch.events.GesturePhase;
import org.gestouch.events.PanGestureEvent;
import org.gestouch.events.ZoomGestureEvent;
import org.gestouch.gestures.Gesture;
import org.gestouch.gestures.PanGesture;
import org.gestouch.gestures.ZoomGesture;

/**
 * ...
 * @author Geun
 */

class QGeustureInteractionSystem extends System
{
	private var camera:IsoCamera;
	private var quadTree:QuadTree<QTreeItemNode>;
	private var controller:MouseController;
	private var grid:IGrid;
	private var stage:Stage;

	public function new(quadTree:QuadTree<QTreeItemNode>, camera:IsoCamera, controller:MouseController, grid:IGrid) 
	{
		super();
		
		this.camera = camera;
		this.quadTree = quadTree;
		this.controller = controller;
		this.grid = grid;
		
		//stage = Lib.current.stage;
		init();
	}
	
	private function init() 
	{
		//result = new QuarryResult();
		//requestAABB = new AABB2();
		
		var view:DisplayObjectContainer = controller.container;
		var back = new Bitmap(new BitmapData(Std.int(camera.renderBounds.intervalX), Std.int(camera.renderBounds.intervalY), false, 0xa8cd3f));
		var background:Sprite = new Sprite();
		background.addChild(back);
		view.addChildAt(background, 0);
		
		//view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		//view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		//view.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		
		
		
		var customDelgegate:CustomDelgegate = new CustomDelgegate();
		
		var pan:PanGesture = new PanGesture(view);
		pan.maxNumTouchesRequired = 2;
		pan.delegate = customDelgegate;
		pan.addEventListener(PanGestureEvent.GESTURE_PAN, onPanGesture);
		
		var zoom:ZoomGesture = new ZoomGesture(view);
		zoom.delegate = customDelgegate;
		zoom.addEventListener(ZoomGestureEvent.GESTURE_ZOOM, onZoomGesture);
		
		
	}
	
	private function onPanGesture(e:PanGestureEvent):Void 
	{
		//var dx = camera.viewPoint.centerX + e.offsetX;
		//var dy = camera.viewPoint.centerY + e.offsetY;
		//var dx = e.stageX - e.offsetX;
		//var dy = e.stageY - e.offsetY;
		
		var state = e.target.state;
		if (state == GestureState.BEGAN || state == GestureState.CHANGED)
		{
			var dx =  e.offsetX;
			var dy =  e.offsetY;
			camera.moveCamera(dx, dy);
		}
		
	}
	
	
	private function onZoomGesture(e:ZoomGestureEvent):Void 
	{
		//var loc:Point = globalToLocal(zoom.location);
		
		//trace(e.currentTarget);
		//trace(e.target);
		//var target:Sprite = container;
		
		var state = e.target.state;
		//var phase = e.target.phase;
		if (state == GestureState.BEGAN || state == GestureState.CHANGED)
		{
			if (camera.scale > 0.5 && camera.scale < 1.3 )
			{
				camera.scale *= e.scaleX;
				//camera.scale += 0.05;
				
				//if (e.scaleX > 1)
				//{
					//camera.scale += 0.05;
				//}
				//else
				//{
					//camera.scale -= 0.05;
				//}
				
				//controller.previousPoint.x = e.localX;
				//controller.previousPoint.y = e.localY;
				//if(e.scaleX > 1)
				//{
					//camera.scale += ((e.scaleX - 1) * 0.1);
				//}
				//{
				//else
					//camera.scale -= ((1 - e.scaleX) * 0.1);
				//}
			}
			else if (camera.scale >= 1.3)
			{
				camera.scale = 1.29;
			}			
			else if (camera.scale <= 0.5)
			{
				camera.scale = 0.51;
			}
		}
		else
		{
			//controller.previousPoint.x = 0;
			//controller.previousPoint.y = 0;
		}
		
		
		/*
		
		if (camera.scale > 0.5 && camera.scale < 1.3 )
		{
			camera.scale *= e.scaleX;
		}
		else if (camera.scale >= 1.3)
		{
			camera.scale = 1.29;
		}			
		else if (camera.scale <= 0.5)
		{
			camera.scale = 0.51;
		}*/
		
		
		//if (e.scaleX > 0.5 || e.scaleX < 1.3)
		//{	
			//camera.scale = e.scaleX;
			//var matrix:Matrix = target.transform.matrix;
			//var transformPoint:Point = matrix.transformPoint(new Point(e.localX, e.localY));
			//matrix.translate(-transformPoint.x, -transformPoint.y);
			//matrix.scale(e.scaleX, e.scaleY);
			//matrix.translate(transformPoint.x, transformPoint.y);
			//target.transform.matrix = matrix;
		//}
	}
	
	private function onWheel(e:MouseEvent):Void 
	{
		
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		
	}
	
}




private class CustomDelgegate implements IGestureDelegate
{
	
	public function new()
	{
		
	}
	public function gestureShouldReceiveTouch(gesture : Gesture, touch : Touch) : Bool
	{
		return true;
	}
	public function gestureShouldBegin(gesture : Gesture) : Bool
	{
		return true;
	}
	public function gesturesShouldRecognizeSimultaneously(gesture : Gesture, otherGesture : Gesture) : Bool
	{
		if (gesture.target == otherGesture.target)
		{
			return true;
		}
		
		return false;
	}
}
