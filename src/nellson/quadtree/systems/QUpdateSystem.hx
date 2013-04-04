package nellson.quadtree.systems;
import nellson.core.Game;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.tools.ListIteratingSystem;
import nellson.ds.AABB2;
import nellson.core.NodeList;
import nme.Lib;

/**
 * QuadTree로 1) culling, 2) soring, 3) rendering을 실시
 * @author Geun
 */

 
class QUpdateSystem extends System
{
	private var quadTree:QuadTree<QTreeItemNode>;
	private var nodes:NodeList<Dynamic>;
	private var list:Array<QuadTreeProxy<QTreeItemNode>>; // 전체 프록시

	public function new(quadTree:QuadTree<QTreeItemNode>) 
	{
		super();
		this.quadTree = quadTree;
		list = [];
	}
	
	override public function addToGame(game:Game):Void 
	{
		super.addToGame(game);
		nodes = game.getNodeList(QTreeItemNode);
		
		//trace('add To Game');
		nodes.nodeAdded.add(addProxy);
		nodes.nodeRemoved.add(removeProxy);
	}
	
	private function removeProxy(node:QTreeItemNode):Void 
	{
		//trace(['이제 좀 지우자', node.info.name , node.info.id]);
		quadTree.removeProxy(node.info.id);
		list = quadTree.getProxyList();
	}
	
	private function addProxy(node:QTreeItemNode):Void 
	{
		node.info.id = quadTree.createProxy(node);
		list = quadTree.getProxyList();
		quadTree.updateProxy(node.info.id);
		
		//trace('quadtree Item ' + quadTree.proxyCount);
		//trace(['넣었다.', node.info.name , node.info.id]);
		//trace(node.info.name);
		
		//trace(list.length);
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		super.removeFromGame(game);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		
		for (proxy in list)
		{
			quadTree.updateProxy(proxy.id);
		}
	}
}