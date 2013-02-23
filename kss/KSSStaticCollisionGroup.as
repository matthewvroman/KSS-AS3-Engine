package org.kss 
{
	import flash.geom.Rectangle;
	import org.kss.components.KSSCollider;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSStaticCollisionGroup extends KSSCollisionGroup 
	{
		
		private var _soleChecker:KSSCollider;
		public function set checker(collider:KSSCollider) { _soleChecker = collider; }
		
		public function KSSStaticCollisionGroup(groupName:String = "", collider:KSSCollider=null) 
		{
			super(groupName);
			_soleChecker = collider;
		}
		
		override public function Check():void
		{
			for (var i:int = 0; i < _numMembers; i++)
			{
				Collision(_soleChecker, _members[i]);
			}

		}
		
	}

}