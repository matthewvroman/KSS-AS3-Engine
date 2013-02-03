package org.kss.tilemaps 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXTile 
	{
		private var _gid:int;
		public function get GID():int { return _gid; }
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; }
		
		public function TMXTile(gid:int, rect:Rectangle) 
		{
			_gid = gid;
			_rect = rect;
			trace("Tile " + _gid + " : " + _rect);
		}
		
	}

}