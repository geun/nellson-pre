package nellson.renderer;
import nellson.blit.components.ITilesheet;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nme.display.DisplayObject;
import nme.events.Event;

/**
 * ...
 * @author Geun
 */

interface IViewport 
{
	public function render(renderNodes:QuarryResult):Void;
	public function resize():Void;
	
	
	#if !flash
	public function addTileSheet(tilesheet:ITilesheet):Void;
	public function hasTileSheet(tilesheet:ITilesheet):Bool;
	public function removeTileSheet(tilesheet:ITilesheet):Void;
	#end
	
}