package nellson.quadtree.systems;
import nellson.components.camera.Camera;
import nellson.core.Game;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.isometirc.components.IsoSpatial;
import nellson.quadtree.nodes.QTreeItemNode;
import newtest.quadtree.comp.TestUtil;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;

/**
 * ...
 * @author Geun
 */

class QuadTreeRenderSystem extends System
{
	private var quadTree:QuadTree<QTreeItemNode>;
	private var container:DisplayObjectContainer;
	private var treeTile:Shape;
	private var camera:Camera;
	private var center:Sprite;
	
	public function new(container:DisplayObjectContainer, quadTree:QuadTree<QTreeItemNode>, camera:Camera) 
	{
		super();
		this.quadTree = quadTree;
		this.container = container;
		this.camera = camera;
		
		treeTile = new Shape();
		container.addChild(treeTile);
		
	}
	
	override public function addToGame(game:Game):Void 
	{
		
	}
	
	override public function update(time:Float):Void 
	{
		treeTile.graphics.clear();
		
		var cameraOffsetX = camera.renderBounds.minX - camera.offset  + camera.drawPoint.x + (camera.renderBounds.intervalX * 0.5);
		var cameraOffsetY = camera.renderBounds.minY - camera.offset  + camera.drawPoint.y + (camera.renderBounds.intervalY * 0.5);
		
		var x = - camera.viewPoint.centerX + camera.renderBounds.minX - cameraOffsetX;
		var y = - camera.viewPoint.centerY + camera.renderBounds.minY - cameraOffsetY;
			
		for ( node in quadTree.nodes)
		{
			
			if( node.debugAABB.minX < camera.renderBounds.maxX && node.debugAABB.minY < camera.renderBounds.maxY)
			TestUtil.drawISOAABB(treeTile, node.debugAABB, false, 0, x, y);
		}
	}
	
}