package org.kss.tilemaps 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXTileInfo //used mainly for collision
	{
		public var tile:TMXTile;
		public var pos:Point;
		
		public function TMXTileInfo(tileInfo:TMXTile,worldPos:Point) 
		{
			tile = tileInfo;
			pos = worldPos;
		}
		
	}

}