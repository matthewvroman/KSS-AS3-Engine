package org.kss.tilemaps 
{
	import flash.geom.Rectangle;
	import org.kss.tilemaps.TMXBase;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXTile extends TMXBase
	{
		private var _gid:uint;
		public function get GID():uint { return _gid; }
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; }
		
		
		public function TMXTile(gid:uint, rect:Rectangle) 
		{
			_gid = gid;
			_rect = rect;
		}
		
	}

}