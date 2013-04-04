package nellson.tools;

/**
 * ...
 * @author Geun
 */

class ArraySortingUtill
{

	public function new() 
	{
		
	}
	static function insertionSort(a:Array<T>, first:Int, k:Int, cmp:T->T->Int):Void
	{
		for (i in first + 1...first + k)
		{
			var x = a[i];
			var j = i;
			while (j > first)
			{
				var y = a[j - 1];
				if (cmp(y, x) > 0)
				{
					a[j] = y;
					j--;
				}
				else
					break;
			}
			
			a[j] = x;
		}
	}
	
	static function quickSort(a:Array<T>, first:Int, k:Int, cmp:T->T->Int):Void
	{
		var last = first + k - 1;
		var lo = first;
		var hi = last;
		if (k > 1)
		{
			var i0 = first;
			var i1 = i0 + (k >> 1);
			var i2 = i0 + k - 1;
			var t0 = a[i0];
			var t1 = a[i1];
			var t2 = a[i2];
			var mid:Int;
			var t = cmp(t0, t2);
			if (t < 0 && cmp(t0, t1) < 0)
				mid = cmp(t1, t2) < 0 ? i1 : i2;
			else
			{
				if (cmp(t1, t0) < 0 && cmp(t1, t2) < 0)
					mid = t < 0 ? i0 : i2;
				else
					mid = cmp(t2, t0) < 0 ? i1 : i0;
			}
			
			var pivot = a[mid];
			a[mid] = a[first];
			
			while (lo < hi)
			{
				while (cmp(pivot, a[hi]) < 0 && lo < hi) hi--;
				if (hi != lo) 
				{
					a[lo] = a[hi];
					lo++;
				}
				while (cmp(pivot, a[lo]) > 0 && lo < hi) lo++;
				if (hi != lo)
				{
					a[hi] = a[lo];
					hi--;
				}
			}
			
			a[lo] = pivot;
			quickSort(a, first, lo - first, cmp);
			quickSort(a, lo + 1, last - lo, cmp);
		}
	}
	
	
	
	private function compare(a:QTreeItemNode, b:QTreeItemNode):Int
	{
		var s1:IsoSpatial = a.isoSpatial;
		var s2:IsoSpatial = b.isoSpatial;
		
		if ( s1.zIndex ==  s2.zIndex) return 0;
		if ( s1.zIndex > s2.zIndex) return 1;
		else return -1;
	}
	
}