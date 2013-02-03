package org.kss 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.kss.components.KSSCollider;
	import org.kss.KSSCollisionGroup;
	import org.kss.KSSEntity;
	import org.kss.KSSEngine;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSState extends KSSObject 
	{
		protected var _engine:KSSEngine;
		private var _canvas:KSSCanvas;
		public function get Canvas():KSSCanvas { return _canvas; }
		private var _entities:Vector.<KSSEntity> = new Vector.<KSSEntity>();
		
		private var _activeRect:Rectangle;
		public function get activeRect():Rectangle { return _activeRect; }
		public function set activeRect(rect:Rectangle):void
		{
			_activeRect = rect.clone();
			_activeRect.x -= _activeRectBuffer;
			_activeRect.y -= _activeRectBuffer;
			_activeRect.width += _activeRectBuffer * 2;
			_activeRect.height += _activeRectBuffer * 2;
			
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_activeRect.containsPoint(_entities[i].position))
				{
					_entities[i].active = true;
				}
				else 
				{
					_entities[i].active = false;
				}
			}
		}
		
		private var _activeRectBuffer:Number=0;
		public function set activeRectBuffer(buffer:Number):void 
		{ 
			_activeRectBuffer = buffer;
			
			if (!_activeRect) return;
			
			_activeRect.x -= _activeRectBuffer;
			_activeRect.y -= _activeRectBuffer;
			_activeRect.width += _activeRectBuffer * 2;
			_activeRect.height += _activeRectBuffer * 2;
		}
		
		private var _collisionGroups:Vector.<KSSCollisionGroup> = new Vector.<KSSCollisionGroup>();
		private var _numCollisionGroups:int = 0;
		
		public function KSSState(engine:KSSEngine) 
		{
			_engine = engine;
			_canvas = _engine.WriteCanvas;
			super();
			
		}
		
		override public function Awake():void
		{

		}
		
		override public function PreUpdate():void
		{
			super.PreUpdate();
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				_entities[i].PreUpdate();
			}
			
		}
		
		override public function Update():void
		{
			super.Update();
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				_entities[i].Update();
			}
			
			for (var j:int = 0; j < _numCollisionGroups; j++)
			{
				_collisionGroups[j].Check();
			}
			
		}
		
		override public function LateUpdate():void
		{
			super.LateUpdate();
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				_entities[i].LateUpdate();
			}
			
		}
		
		public function AddEntity(entity:KSSEntity):void
		{
			_entities.push(entity);
		}
		
		public function RemoveEntity(entity:KSSEntity):Boolean
		{
			var idx:int = _entities.indexOf(entity);
			if (idx != -1)
			{
				entity.Destroy();
				_entities.splice(idx, 1);
				return true;
			}
			return false;
		}
		
		public function GetEntityOfType(type:Class):KSSEntity
		{
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_entities[i] is type)
				{
					return _entities[i];
				}
			}
			
			return null;
		}
		
		public function GetEntitiesOfType(type:Class):Vector.<KSSEntity>
		{
			var classEntities:Vector.<KSSEntity> = new Vector.<KSSEntity>();
			
			var length:int = _entities.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_entities[i] is type)
				{
					classEntities.push(_entities[i]);
				}
			}
			
			if (classEntities.length > 0)
				return classEntities;
				
			return null;
		}
		
		public function RegisterCollider(collider:KSSCollider, collisionGroup:String=""):Boolean
		{
			var registered:Boolean;
			for (var i:int = 0; i < _numCollisionGroups; i++)
			{
				if (_collisionGroups[i].name == collisionGroup)
				{
					_collisionGroups[i].AddMember(collider);
					registered = true;
				}
			}
			
			if (!registered)
			{
				var newGroup:KSSCollisionGroup = new KSSCollisionGroup(collisionGroup);
				newGroup.AddMember(collider);
				_collisionGroups.push(newGroup);
				registered = true;
			}
			
			_numCollisionGroups = _collisionGroups.length;
			
			return registered;
		}
		
		public function UnregisterCollider(collider:KSSCollider):Boolean
		{
			for (var i:int = 0; i < _numCollisionGroups; i++)
			{
				if (_collisionGroups[i].RemoveMember(collider))
					return true;
			}
			
			return false;
		}
		
		public function RegisterCollisionGroup(groupName:String):Boolean
		{
			var newGroup:KSSCollisionGroup = new KSSCollisionGroup(groupName);
			_collisionGroups.push(newGroup);
			_numCollisionGroups = _collisionGroups.length;
			
			return true;
		}
		
		public function UnregisterCollisionGroup(groupName:String):Boolean
		{
			for (var i:int = 0; i < _numCollisionGroups; i++)
			{
				if (_collisionGroups[i].name == groupName)
				{
					_collisionGroups.splice(i, 1);
					_numCollisionGroups = _collisionGroups.length;
					return true;
				}
			}
			return false;
		}
		
		override public function Destroy():void
		{
			super.Destroy();
			while (_entities.length > 0)
			{
				var entity:KSSEntity = _entities.pop();
				entity.Destroy();
			}
		}
		
	}

}