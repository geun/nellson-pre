package nellson.quadtree.components;
import nellson.isometirc.components.IsoSpatial;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.ds.AABB2;

//using de.polygonal.ds.ArrayUtil;

/**
 * ...
 * @author Geun
 */

//typedef QuarryResult = Array<QTreeItemNode>;
class QuarryResult 
{
	public var data:Array<QTreeItemNode>;
	public var debug:Array<AABB2>;
	public function new() 
	{
		this.data = new Array();
		debug = new Array<AABB2>();
	}
	
	public function reset():Void
	{
		data = [];
		debug = [];
	}
	
	public function sort(order:Bool = true):Array<QTreeItemNode>
	{
		nativeSortDirectAcces(order);
		return data;
	}

	private function nativeSortDirectAcces(order:Bool):Void
	{
		function a(a:QTreeItemNode, b:QTreeItemNode):Int {
			var s1:IsoSpatial = a.isoSpatial;
			var s2:IsoSpatial = b.isoSpatial;
			
			if ( s1.zIndex ==  s2.zIndex) return 0;
			if ( s1.zIndex > s2.zIndex) return 1;
			else return -1;
		}
		
		function b(a:QTreeItemNode, b:QTreeItemNode):Int {
			var s1:IsoSpatial = a.isoSpatial;
			var s2:IsoSpatial = b.isoSpatial;
			
			if ( s1.zIndex ==  s2.zIndex) return 0;
			if ( s1.zIndex > s2.zIndex) return -1;
			else return 1;
		}
		
		if (order) data.sort(a);
		else data.sort(b);
	}
}
