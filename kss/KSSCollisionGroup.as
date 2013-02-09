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
		
		public function CheckAgainstTiles(_collider:KSSCollider):void
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
		
		//checks within the group
		public function Check():void
		{
			if (_map)
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