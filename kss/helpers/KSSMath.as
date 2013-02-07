package org.kss.helpers 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSMath 
	{
		
		public function KSSMath() 
		{
			
		}
		
		public static function AddPoints(p1:Point, p2:Point):Point
		{
			return new Point(p1.x + p2.x, p1.y + p2.y);
		}
		
		public static function SubtractPoints(p1:Point, p2:Point):Point
		{
			return new Point(p1.x - p2.x, p1.y - p2.y);
		}
	}

}