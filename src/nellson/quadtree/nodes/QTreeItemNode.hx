package nellson.quadtree.nodes;
import nellson.blit.components.BlitSpritesheet;
import nellson.blit.components.BlitSpritesheetGraphics;

//import nellson.blit.components.SpriteSheet;
//import nellson.blit.components.BlitGraphicsData;

import nellson.components.display.GameLayer;
import nellson.components.Info;
import nellson.components.Transforms;

import nellson.core.Node;
import nellson.ds.IQuadItem;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.ds.AABB2;
 
/**
 * 렌더링과 소팅 데이터를 포함
 * @author Geun
 */

class QTreeItemNode extends Node, implements IQuadItem
{
	public var info:Info;
	public var layer:GameLayer;
	public var aabb:AABB2;
	
	/**
	 * entity.get 하는 것이 맞으나. 속도때문에 집접접근함. 나중에 QtreeItem을 상속해서 QTreeIsoItem 을 생성하기. 
	 */
	public var isoSpatial:IsoSpatial;
	
	//public var isoTile:IsoTile;
	
	//public var spriteSheet:SpriteSheet;
	//public var graphicsData:BlitGraphicsData;
	//public var transforms:Transforms;
	
	public var blitGraphicsData:BlitSpritesheetGraphics;
	public var blitSpritesheet:BlitSpritesheet;
	
	
	public function new() 
	{
		super();
	}
}