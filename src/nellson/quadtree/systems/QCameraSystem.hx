package nellson.quadtree.systems;
import nellson.components.camera.Camera;
import nellson.components.controller.MouseController;
import nellson.core.Game;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.isometirc.components.IsoCamera;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.ds.AABB2;
import nme.display.Stage;
import nme.events.MouseEvent;
import nme.Lib;

/**
 * ...
 * @author Geun
 */

class QCameraSystem extends System
{
	public var camera:Camera;
	private var controller:MouseController;
	private var stage:Stage;
	private var quadTree:QuadTree<QTreeItemNode>;
	private var renderNodes:QuarryResult;
	private var debugAABB:Array<AABB2>;
	private var dirty:Bool;
	
	public function new(camera:Camera, controller:MouseController, quadTree:QuadTree<QTreeItemNode>, renderNodes:QuarryResult) 
	//public function new() 
	{
		super();
		
		stage = Lib.current.stage;
		this.camera = camera;
		this.controller = controller;
		this.renderNodes = renderNodes;
		this.quadTree = quadTree;
		trace(this.camera);
		trace(camera.aabb.toString());
		
		dirty = true;
	}
	
	override public function addToGame(game:Game):Void 
	{
		
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		
	}
	
	override public function update(time:Float):Void 
	{
		//trace('camear update : ' +  renderNodes.data.length);
		//if (camera.scaleDirty && camera.cameraInited) camera.scaleDirty = false;
		if (dirty)
		{
			renderNodes.reset();
			var num = quadTree.queryAABB(camera.aabb, renderNodes.data, 10000, renderNodes.debug);
			//trace('renderNodes Num : ' + renderNodes.data.length);
			//dirty = false;
		}
		//if (!camera.cameraInited) camera.cameraInited = true;
		
		
	}
}