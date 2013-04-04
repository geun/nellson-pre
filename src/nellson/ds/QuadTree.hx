package nellson.ds;
import  nellson.ds.IQuadItem;
import nellson.quadtree.nodes.QTreeItemNode;
import de.polygonal.core.math.Limits;
import de.polygonal.ds.DA;
import de.polygonal.ds.DA;
import de.polygonal.ds.DA;
import de.polygonal.ds.DA;
import de.polygonal.ds.DLL;
import de.polygonal.ds.pooling.ObjectPool;
import nellson.ds.AABB2;
import nme.display.Shape;
import nme.errors.Error;


/**
 * ...
 * @author Geun
 * 
 * Game Programming Gems, Multi-Resolution Maps for Interaction Detection
 * Game Programming Gems II, Direct Access Quadtree Lookup
 */

 
class QuadTree<T:IQuadItem>
{
	private var depth:Int;
	private var xScale:Float;
	private var yScale:Float;
	
	private var proxyPool:ObjectPool<QuadTreeProxy<T>>;
	public var proxyCount(default, null) :Int;
	
	public var proxyList:QuadTreeProxy<T>;
	public var nodes(default, null):Array<QuadTreeNode<T>>;
	
	#if flash
	private var offsets:flash.Vector<Int>;
	#else
	private var offsets:Array<Int>;
	#end
	
	
	private var xOffset:Float;
	private var yOffset:Float;
	
	private var bound:AABB2;
	
	private var isInitialize:Bool;
	static private inline var MAX_PROXY:Int = 1 << 11; // 512개 :9 1024 : 10  2048 : 11 4056/ 12 : 13 8192
	
	public function new(worldBound:AABB2, depth:Int = 5) 
	{
	
		this.depth = depth;
		bound = worldBound;
		//proxyList = null;
		proxyCount = 0; 
		init();
	}
	
	public function setScale(scale:Float = 1.0):Void
	{
		this.xScale *= scale;
		this.yScale *= scale;
	}
	
	private function init():Void
	{
		initProxytPool();
		createAllNode();
		isInitialize = true;
		
	}
	
	private function createAllNode():Void
	{
		for ( proxy in proxyPool) proxy.reset(); // 전체 초기화
		
		var w = Std.int(bound.maxX - bound.minX);
		var h = Std.int(bound.maxY - bound.minY);
		
		xOffset = bound.minX < 0 ? -bound.minX : 0;
		yOffset = bound.minY < 0 ? -bound.minY : 0;
		
		#if flash
		var memory = flash.system.System.totalMemory;
		#end

		// 트리 사이즈 루트가 한개, 아래로 4개 까지 확장 5일때 16 =  2^4
		var treeSize = 1 << (depth - 1); 
		
		//node scale factor
		xScale = treeSize / w; // 0.04
		yScale = treeSize / h;
		
		
		//compute total number of nodes,
		//from lowest -> highest resolution
		var c = -1;
		for (i in 0...depth) c += (1 << (i << 1));
		
		
		//배열 생성, 첫번째 노드는 사용안함.
		nodes = new Array<QuadTreeNode<T>>();
		
		#if flash
		offsets = new flash.Vector<Int>();
		#else
		offsets = new Array<Int>();
		#end
		
		offsets[0] = -1;
		
		
		
		
		//노드 생성, 위에서 아래로. 
		//allocate nodes, from lowest -> highest resolution
		var offset = -1;
		for (i in 0...depth)
		{
			var levelEdgeSize = 1 << i; // 1, 2, 4, 8, 16 
			
			offsets[i + 1] = offset + 1; // 각 레벨의 첫번째 값 을 저장;
			
			//node 사이즈 계산 // 디버그용으로 사용.
			var xsize = treeSize >> i;
			var ysize = xsize;
			xsize *= Std.int(w / treeSize);
			ysize *= Std.int(h / treeSize);
			
			
			//두번 돌아서 x, y를 생성
			for ( y in 0...levelEdgeSize)
			{
				for (x in 0...levelEdgeSize)
				{
					var node = new QuadTreeNode();
					var addr = (offset + 1) + (y * levelEdgeSize + x); // 
					nodes[addr] = node;
					
					node.debugAABB.minX = Std.int(x * xsize + bound.minX);
					node.debugAABB.minY = Std.int(y * ysize + bound.minY);
					node.debugAABB.maxX = Std.int(node.debugAABB.minX + xsize);
					node.debugAABB.maxY = Std.int(node.debugAABB.minY + ysize);
				}
			}
			
			offset += (1 << ( i << 1));
		}
		
		
		//부모포인터를 저장함., go from highest -> lowest resolution
		var i = depth;
		while ( i > 1)
		{
			var levelEdgeSize = 1 << (i -1); // 맨위의 사지즈 
			offset = offsets[i];
			var parentOffset = offsets[i - 1];
			for ( y in 0...levelEdgeSize)
			{
				for ( x in 0...levelEdgeSize)
				{
					var addr0 = offset + y * levelEdgeSize + x;
					var addr1 = parentOffset + ( y >> 1) * ( levelEdgeSize >> 1) + (x >> 1);
					nodes[addr0].parent = nodes[addr1];
				}
			}
			i--;
		}
		
		/*#if flash
		trace("QUADTREE STATISTICS:");
		trace("max proxies:"+ MAX_PROXY);
		trace("memory: " + ((flash.system.System.totalMemory - memory) >> 10));
		trace("depth: " + Std.int(depth + 1));
		trace("unscaled tree size: "+ treeSize);
		trace("quad node scale: " + xScale + ' / '+ yScale);
		trace("root node size: " + w + ' / ' + h);
		trace("leaf node size: " +Std.string( 1 / xScale) +' / '+ Std.string( 1 / yScale));
		#end*/

	}
	
	/**
	 *  Debug only
	 * 
	 * @return
	 */
	public function getProxyList():Array<QuadTreeProxy<T>>
	{
		var list:Array<QuadTreeProxy<T>> = new Array<QuadTreeProxy<T>>();
		var p:QuadTreeProxy<T> = proxyList;
		while (p != null)
		{
			list.push(p);
			p = p.nextInTree;
		}
		return list;
	}
	
	private function initProxytPool():Void
	{
		proxyPool = new ObjectPool<QuadTreeProxy<T>>(MAX_PROXY);
		var _class:Class<QuadTreeProxy<T>> = Type.getClass(new QuadTreeProxy<T>());
		
		proxyPool.allocate(false, _class); // 전체 노드 생성
	}
	
	public function createProxy(item:T):Int
	{
		var proxyid:Int = proxyPool.next();
		var proxy = proxyPool.get(proxyid);
		proxy.id = proxyid;
		proxy.item = item;
		
	//	trace('comp');
		
		// proxyList head 설정하기.
		proxy.nextInTree = proxyList;
		if (proxyList != null) proxyList.prevInTree = proxy;
		proxyList = proxy;
		
		//proxy를 tree 에 직접삽입하기/ 직접접근 알고리즘 사용.
		getNodeContaining(proxy).insert(proxy);
		proxyCount++;
		return proxyid;
	}
	
	 /**
	  * 
	  * 빠른 접근을 위해서 재귀호출로 돌지 않고
	  * 벡터에다가 넣어두고 직접접근해서 사용함. 
	  * gpg2권 직접 쿼리 접근 참조. 
	  * 
	  * @param	proxy
	  * @return
	  */
	 public function getNodeContaining(proxy:QuadTreeProxy<T>):QuadTreeNode<T>
	{
		var item = proxy.item;
		
		var xl = minX(item); //좌측 상단 좌표 
		var yt = minY(item); 
		
		var xr = xl ^ maxX(item); // minX ^ maxX or 연산...
		var yr = yt ^ maxY(item);
		
		var level = depth;
		while (xr + yr != 0)
		{
			xr >>= 1;
			yr >>= 1;
			level--;
			
			
		}
		
		var shift = depth - level;
		xl >>= shift;
		yt >>= shift;
		
		return getNode(level, xl, yt);
	}
	
	
	/**
	 * 
	 *  256,512,1024
	 *  2의 지수승으로 미리 생성된 노드들을 집접 접근함.
	 * 
	 * @param	level
	 * @param	x
	 * @param	y
	 * @return
	 */
	
	inline private function getNode(level:Int, x:Int, y:Int):QuadTreeNode<T>
	{
		//trace('node position : ' + Std.int(offsets[level] + (y << (level - 1)) + x));
		return nodes[offsets[level] + (y << (level - 1)) + x];
	}
	
	inline function minX(item:IQuadItem):Int { return Std.int((item.aabb.minX + xOffset) * xScale); }
	inline function minY(item:IQuadItem):Int { return Std.int((item.aabb.minY + yOffset) * yScale); }
	inline function maxX(item:IQuadItem):Int { return Std.int((item.aabb.maxX + xOffset) * xScale); }
	inline function maxY(item:IQuadItem):Int { return Std.int((item.aabb.maxY + yOffset) * yScale); }
	
	
	public function removeProxy(id:Int):Void
	{
		var p1 = proxyPool.get(id);
		var p2:QuadTreeProxy<T> = proxyList;
		
		var s1 = p1.item;
		var s2:T;
		
		var a = s1.aabb;
		var _minX = a.minX, _maxX = a.maxX;
		var _minY = a.minY, _maxY = a.maxY;
		
		// 안으로 탐색.
		while ( p2 != null)
		{
			if ( p1 == p2)
			{
				p2 = p2.nextInTree;
				continue;
			}
			
			s2 = p2.item;
			a = s2.aabb;
			if ( _minX > a.maxX || _maxX < a.minX || _minY > a.maxY || _maxY < a.minY)
			{
				p2 = p2.nextInTree;
				continue;
			}
			
			
			// 충돌 체크시 페어 활용
			p2 = p2.nextInTree;
			
		}
		
		
		// head 에서 node link 제거하기.
		p1.remove();
		
		// tree 에서 link 제거하기.
		if (p1.prevInTree != null) p1.prevInTree.nextInTree = p1.nextInTree;
		if (p1.nextInTree != null) p1.nextInTree.prevInTree = p1.prevInTree;
		if (p1 == proxyList) proxyList = p1.nextInTree;
		
		p1.reset();
		
		
		//완전 제거하기. 
		proxyPool.put(id);
		
		p1.id = Proxy.NULL_PROXY;
		p1.item = null;
		
		proxyCount--;
	}
	
	public function updateProxy(id:Int):Void
	{
		var proxy = proxyPool.get(id);
		
		//trace('proxy' + proxy);
		var item = proxy.item;
		
		// aabb 값이 변했는지 확인
		var x1 = Std.int(item.aabb.minX);
		var y1 = Std.int(item.aabb.minY);
		
		
		//trace('updateProxy '  + x1 + ' / ' + y1);
		//trace(item.aabb);
		// aabb 값이 안변했으면 리턴해 
		if (proxy.minX == x1 && proxy.minY == y1) return ; 
		
		// 캐싱 하기. 
		proxy.minX = x1;
		proxy.minY = y1;
		
		
		// 새로운 포지션 넣기
		var xl = minX(item);
		var yt = minY(item);
		
		var xr = xl ^ maxX(item);
		var yr = yt ^ maxY(item);
		
		var level = depth;
		while (xr + yr != 0 )
		{
			xr >>= 1;
			yr >>= 1 ;
			level--;
		}
		
		var shift = depth - level;
		xl >>= shift;
		yt >>= shift;
		
		
		// proxy의 현재 위치를 확인해서 새로 계산된  위치값과 같으면 그냥 리턴함.
		if (xl == proxy.x && yt == proxy.y) return;
		
		proxy.x = xl; // 새 노드 위치 설정
		proxy.y = yt;
		
		proxy.remove(); // 프록시 링크드 리스트 정보를 삭제함. 
		var node = proxy.node = getNode(level, xl, yt);
		node.insert(proxy);
		
		
	}
	
	
	
	public function insideBound(targetBound:AABB2):Bool
	{
		if ( targetBound.minX < bound.minX) return false;
		if ( targetBound.maxX >= bound.maxX) return false;
		if ( targetBound.minY < bound.minY) return false;
		if ( targetBound.maxY >= bound.maxY) return false;
		return true;
	}
	
	public function queryAABB(aabb:AABB2, out:Array<T>, maxCount:Int, ?debugData:Array<AABB2>):Int
	{
		var _minX = aabb.minX;
		var _maxX = aabb.maxX;
		var _minY = aabb.minY;
		var _maxY = aabb.maxY;
		
		var p = proxyList;
		var i = 0;
		while ( p != null)
		{
			var item = p.item;
			if (item.aabb.minX > _maxX || item.aabb.maxX < _minX || item.aabb.minY > _maxY || item.aabb.maxY < _minY)
			{
				p = p.nextInTree;
				continue;
			}
			
			out.push(item);
			if (debugData != null)
				debugData.push(p.node.debugAABB);
			if (i++ == maxCount) break;
			
			p = p.nextInTree;
		}
		return i;
	}
	
}

class QuadTreeNode<T>
{
	public var parent:QuadTreeNode<T>;
	public var proxyList:QuadTreeProxy<T>;
	
	public var debugAABB:AABB2;
	
	public function new()
	{
		parent = null;
		proxyList = null;
		debugAABB = new AABB2();
	}
	
	inline public function insert(proxy:QuadTreeProxy<T>):Void
	{
		proxy.prevInNode = null;
		proxy.nextInNode = proxyList;
		if ( proxyList != null) proxyList.prevInNode = proxy;
		proxyList = proxy; // 헤드로 설정
		proxy.node = this; // 프록시의 부모노드로 설정 
		
	}
}

class QuadTreeProxy<T> extends Proxy<T>
{
	public var nextInNode:QuadTreeProxy<T>;
	public var prevInNode:QuadTreeProxy<T>;
	
	public var nextInTree:QuadTreeProxy<T>;
	public var prevInTree:QuadTreeProxy<T>;
	
	public var node:QuadTreeNode<T>; // 프록시가 들어있는 부모 노드
	
	public var overLapCount:Int; //충돌체크용..
	
	/**
	 * 
	 * 현재 위치 노드용 변수
	 * 쿼드 트리를 직접 접근하기 위해서 사용
	 * 
	 */
	public var x:Int;
	public var y:Int;
	
	/**
	 * The current minimum shape bound.
	 */
	public var minX:Int;
	public var minY:Int;
	
	
	/**
	 * 
	 * proxy를 unlink함.
	 * 
	 */
	inline public function remove():Void
	{
		if (prevInNode != null) prevInNode.nextInNode = nextInNode;
		if (nextInNode != null) nextInNode.prevInNode = prevInNode;
		if (node.proxyList == this) node.proxyList = nextInNode; // 삭제하려는 노드가 헤드일 경우 다음 노드를 헤드로 설정 
		
		prevInNode = null;
		nextInNode = null;
		node = null;
	}
	
	public function reset():Void
	{
		nextInNode = null;
		prevInNode = null;
		nextInTree = null;
		prevInTree = null;
		node = null;
		
		x = Limits.INT32_MIN;
		y = Limits.INT32_MIN;
		minX = Limits.INT32_MIN;
		minY = Limits.INT32_MIN;
		
	}
	
}


private class Proxy<T>
{
	inline public static var NULL_PROXY = Limits.INT32_MAX;
	
	public var id:Int;
	public var item:T;
	
	public function new() { }
	
}
