package org.kss 
{
	import org.kss.components.KSSCollider;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCollisionGroup 
	{
		public var name:String;
		private var _members:Vector.<KSSCollider> = new Vector.<KSSCollider>();
		private var _numMembers:int=0; //try to be as optimized as possible and not calculate every frame
		
		public function KSSCollisionGroup(groupName:String="") 
		{
			name = groupName;
		}
		
		//chceks the group against k
		public function CheckWith(k:KSSCollider):Boolean
		{
			return false;
		}
		
		//checks within the group
		public function Check():void
		{
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
				k1.OnCollide(k2);
				k2.OnCollide(k1);
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