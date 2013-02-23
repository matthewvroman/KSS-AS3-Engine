package org.kss 
{
	import flash.geom.Rectangle;
	import org.kss.components.KSSCollider;
	import org.kss.tilemaps.TMXMap;
	import org.kss.tilemaps.TMXTileInfo;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSTileCollisionGroup extends KSSCollisionGroup 
	{
		private var _map:TMXMap;
		private function set tileMap(map:TMXMap):void { _map = map; }
		
		public function KSSTileCollisionGroup(groupName:String="",TileMap:TMXMap=null) 
		{
				super(groupName);
				_map = TileMap;
		}
		
		override public function Check():void
		{
			for (var i:int = 0; i < _numMembers; i++)
			{
				var flags:Vector.<String> = _members[i].CollisionFlags;
				if (flags.length == 0)
				{
					CheckAgainstTiles(_members[i]);
				}else {
					CheckAgainstTileFlags(_members[i]);
				}
			}
		}
		
		private function CheckAgainstTiles(_collider:KSSCollider):void
		{
			var surroundingTiles:Vector.<TMXTileInfo> = _map.getSurroundingTiles(_collider.worldBounds, 2); //TODO: paramatize buffer
			var _numTiles:int = surroundingTiles.length;
			for (var j:int = 0; j < _numTiles; j++)
			{
				if (_collider.worldBounds.intersects(surroundingTiles[j].worldRect))
				{
					_collider.OnTileCollision(surroundingTiles[j]);
				}
			}
		}
		
		private function CheckAgainstTileFlags(_collider:KSSCollider):void
		{
			var flags:Vector.<String> = _collider.CollisionFlags;
			var surroundingTiles:Vector.<TMXTileInfo> = _map.getSurroundingTiles(_collider.worldBounds, 2); //TODO: paramatize buffer
			var _numTiles:int = surroundingTiles.length;
			for (var j:int = 0; j < _numTiles; j++)
			{
				for (var k:int = 0; k < flags.length; k++)
				{
					if(surroundingTiles[j].tile.GetPropertyByName(flags[k])){
						if (_collider.worldBounds.intersects(surroundingTiles[j].worldRect))
						{
							_collider.OnTileCollision(surroundingTiles[j],flags[k]);
						}
					}
				}
				
				
			}
		}
		
	}

}