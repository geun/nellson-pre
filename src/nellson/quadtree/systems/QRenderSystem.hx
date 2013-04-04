package nellson.quadtree.systems;
import nellson.blit.nodes.BlitGraphicsRenderNode;
import nellson.components.camera.Camera;
import nellson.components.display.GameLayer;
import nellson.core.Game;
import nellson.core.NodeList;
import nellson.core.System;
import nellson.isometirc.components.IsoGrid;
import nellson.isometirc.components.IsoSpatial;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.renderer.BMPViewport;
import nellson.renderer.IViewport;
import nellson.renderer.NMEViewport;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;
import nme.text.TextField;

/**
 * ...
 * @author Geun
 */

class QRenderSystem extends System
{
	private var renderNodes:QuarryResult;
	private var container:DisplayObjectContainer;
	private var testShape:Shape;
	
	private var viewport:IViewport;
	private var camera:Camera;
	private var nodeList:NodeList<Dynamic>;
	
	public function new(container:DisplayObjectContainer, camera:Camera, renderNodes:QuarryResult) 
	{
		super();
		this.renderNodes = renderNodes;
		this.container = container;
		this.camera = camera;
		init();
		
		
		
		//var backgroundImg = new back
		
	}
	private function init():Void
	{
		#if flash
		viewport = new BMPViewport(container, camera);
		#else
		viewport = new NMEViewport(container, camera);
		#end
	}
	
	
	override public function addToGame(game:Game):Void 
	{
		//사용된 타일을 다 검사해서, 미리 타일정보를 생성
		
		nodeList = game.getNodeList(BlitGraphicsRenderNode);
		nodeList.nodeAdded.add( nodeAddedFunction );
		nodeList.nodeRemoved.add( nodeRemovedFunction );
		
	}
	
	private function nodeAddedFunction(node:BlitGraphicsRenderNode):Void
	{
		
		#if cpp
		var tilesheet = node.blitSpritesheet.tilesheet;
		if (!viewport.hasTileSheet(tilesheet)) 
		{
			trace('node added ' + node.blitSpritesheet.tilesheet.getName());
			viewport.addTileSheet(tilesheet);
		}
		#end
	}
	
	
	private function nodeRemovedFunction(node:BlitGraphicsRenderNode):Void
	{
		
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		nodeList.nodeAdded.remove( nodeAddedFunction );  // 좀이상함 나중에 에러나면 수정
		nodeList.nodeRemoved.remove( nodeRemovedFunction );
		nodeList = null;
	}
	
	override public function update(time:Float):Void 
	{
		
		//if (camera.scaleDirty)
		//{
			//trace('scaelDirty == true');
			//viewport.resize();
		//}
		viewport.render(renderNodes);
	}
	
}
