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
	public class KSSCollisionGroup 
	{
		public var name:String;
		private var _members:Vector.<KSSCollider> = new Vector.<KSSCollider>();
		private var _numMembers:int = 0; //try to be as optimized as possible and not calculate every frame
		
		private var _map:TMXMap;
		private function set tileMap(map:TMXMap):void { _map = map; }
		
		public function KSSCollisionGroup(groupName:String="",TileMap:TMXMap=null) 
		{
			name = groupName;
			_map = TileMap;
		}
		
		//chceks the group against k
		public function CheckWith(k:KSSCollider):Boolean
		{
			return false;
		}
		
		public function CheckAgainstTiles():void
		{
			
			for (var i:int = 0; i < _numMembers; i++)
			{
				var surroundingTiles:Vector.<TMXTileInfo> = _map.getSurroundingTiles(_members[i].worldBounds, 2); //TODO: paramatize buffer
				var _numTiles:int = surroundingTiles.length;
				for (var j:int = 0; j < _numTiles; j++)
				{
					//if(surroundingTiles[j].tile.GetPropertyByName("collision")){
					/*var tileRect:Rectangle = new Rectangle();
						tileRect.x = surroundingTiles[j].pos.x;
						tileRect.y = surroundingTiles[j].pos.y;
						tileRect.width = surroundingTiles[j].tile.rect.width;
						tileRect.height = surroundingTiles[j].tile.rect.height;*/
						if (_members[i].worldBounds.intersects(surroundingTiles[j].worldRect))
						{
							_members[i].OnTileCollision(surroundingTiles[j]);
						}
					//}
					
					
				}
			}
		}
		
		//checks within the group
		public function Check():void
		{
			if (_map)
			{
				CheckAgainstTiles();
				return;
			}
			
			for (var i:int = 0; i < _numMembers; i++)
			{
				for (var j:int = i; j < _numMembers; j++) //j=i, don't check if the two rects have already been compared
				{
					if(i!=j) //don't check against self
						Collision(_members[i], _members[j]);
				}
			}
		}
		
		public function Collision(k1:KSSCollider, k2:KSSCollider):Boolean
		{
			if (k1.worldBounds.intersects(k2.worldBounds))
			{
				k1.OnCollision(k2);
				k2.OnCollision(k1);
				return true;
			}
			
			return false;
		}
		
		public function AddMember(member:KSSCollider):void
		{
			_members.push(member);
			_numMembers++;
		}
		
		public function RemoveMember(member:KSSCollider):Boolean
		{
			var index:int = _members.indexOf(member);
			if (index != -1)
			{
				_members.splice(index, 1);
				_numMembers--;
			}
			
			return false;
		}
		
		public function set members(group:Vector.<KSSCollider>):void
		{
			_members = group;
			_numMembers = _members.length;
		}
		
		public function get group():Vector.<KSSCollider>
		{
			return _members;
		}
	}

}