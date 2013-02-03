package org.kss.tilemaps 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXTileInfo //used mainly for collision
	{
		public var tile:TMXTile;
		public var pos:Point;
		
		public var worldRect:Rectangle;
		
		public function TMXTileInfo(tileInfo:TMXTile,worldPos:Point) 
		{
			tile = tileInfo;
			pos = worldPos;
			
			worldRect = new Rectangle(pos.x, pos.y, tile.rect.width, tile.rect.height);
		}
		
	}

}