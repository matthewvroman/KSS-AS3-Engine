package org.kss.components 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import org.kss.KSSComponent;
	import org.kss.KSSEntity;
	import org.kss.tilemaps.TMXTileInfo;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCollider extends KSSComponent 
	{	
		public function get entity():KSSEntity { return _entity; }
		
		private var _localBounds:Rectangle;
		private var _worldBounds:Rectangle = new Rectangle(0, 0, 0, 0);
		
		public function get worldBounds():Rectangle { 
			_worldBounds.x = _localBounds.x + _entity.position.x;
			_worldBounds.y = _localBounds.y + _entity.position.y;
			return _worldBounds;
		}
		public var windowBounds:Rectangle;
		
		private var _touchingLeft:Boolean = false;
		private var _touchingRight:Boolean = false;
		private var _touchingUp:Boolean = false;
		private var _touchingDown:Boolean = false;
		
		public function get touchingLeft():Boolean { return _touchingLeft; }
		public function get touchingRight():Boolean { return _touchingRight; }
		public function get touchingUp():Boolean { return _touchingUp; }
		public function get touchingDown():Boolean { return _touchingDown; }
		
		private var _flags:Vector.<String> = new Vector.<String>();
		public function get CollisionFlags():Vector.<String> { return _flags; }
		
		private var _lastFrameCollisions:Vector.<KSSCollider> = new Vector.<KSSCollider>();
		private var _currentCollisions:Vector.<KSSCollider> = new Vector.<KSSCollider>();
		
		private var _type:String;
		public function set type(_collisionType:String):void { _type = _collisionType; }
		public function get type():String { return _type; }
		
		private var _collisionCallback:Function = new Function();
		public function set CollisionCallback(callback:Function):void { _collisionCallback = callback; }
		
		private var _collisionExitCallback:Function = new Function();
		public function set CollisionExitCallback(callback:Function):void { _collisionExitCallback = callback; }
		
		private var _collisionEnterCallback:Function = new Function();
		public function set CollisionEnterCallback(callback:Function):void { _collisionEnterCallback = callback; }
		
		private var _tileCollisionCallback:Function = new Function();
		public function set TileCollisionCallback(callback:Function):void { _tileCollisionCallback = callback; }
		
		public var unembed:Boolean = false;
		
		public var trigger:Boolean = false;
		
		public function AddCollisionFlags(flags:Vector.<String>):void
		{
			_flags.concat(flags);
		}
		public function AddCollisionFlag(flag:String):void
		{
			_flags.push(flag);
		}
		
		public function RemoveCollisionFlag(flag:String):Boolean
		{
			var index = _flags.indexOf(flag);
			if (index != -1)
			{
				_flags.splice(index, 1);
				return true;
			}
			
			return false;
		}
		
		public function get touching():Boolean 
		{ 
			if (_touchingDown || _touchingLeft || _touchingRight || _touchingUp) 
				return true; 
			else
				return false;
		}
		
		public function KSSCollider(entity:KSSEntity,collisionRect:Rectangle=null) 
		{
			super(entity);
			_entity = entity;
			
			_type = entity.name;
			
			if (collisionRect) {
				bounds = collisionRect;
			}
		}
		
		public function set bounds(rect:Rectangle):void
		{
			_localBounds = rect;
			_worldBounds.width = rect.width;
			_worldBounds.height = rect.height;
			_worldBounds.x = rect.x+_entity.position.x;
			_worldBounds.y = rect.y + _entity.position.y;
		}
		
		override public function PreUpdate():void
		{
			if (!active) return;
			
			super.PreUpdate();
			_touchingDown = _touchingLeft = _touchingRight = _touchingUp = false;
			
			//if collider in currentcollisions doesnt exist in last frame then we entered that collider
			//if collider in lastframecollisions doesnt exist in current collisions then we exited that collider
			
			for (var i:int = 0; i < _lastFrameCollisions.length; i++)
			{
				if (_currentCollisions.indexOf(_lastFrameCollisions[i]) == -1)
				{
					//trace("Exit collider " + _lastFrameCollisions[i].name);
					if (_collisionExitCallback)
						_collisionExitCallback(_lastFrameCollisions[i]);
				}
			}
			
			for (var j:int = 0; j < _currentCollisions.length; j++)
			{
				if (_lastFrameCollisions.indexOf(_currentCollisions[j]) == -1)
				{
					//trace("Entered collider " + _currentCollisions[j].name);
					if (_collisionEnterCallback)
						_collisionEnterCallback(_currentCollisions[j]);
				}
			}

			_lastFrameCollisions.length = 0;
			for (var k:int = 0; k < _currentCollisions.length; k++)
			{
				_lastFrameCollisions.push(_currentCollisions[k]);
			}
			_currentCollisions.length = 0;
			
			
		}
		
		private function AddCollision(c:KSSCollider):void
		{
			_currentCollisions.push(c);
		}
		
		public function OnCollision(c:KSSCollider):void
		{
			//trace("collision with " + c + "!");
			if (!c.trigger) 
				determineCollisionAreas(c.worldBounds);
			_collisionCallback(c);
			
			_currentCollisions.push(c);
		}
		
		public function OnTileCollision(t:TMXTileInfo,collisionFlag:String=""):void
		{
			//trace("Collision with tile!" + " Flag: " + collisionFlag);
			determineCollisionAreas(t.worldRect);
			_tileCollisionCallback(t, collisionFlag);
		}
		
		public function determineCollisionAreas(rect:Rectangle):void
		{
			var intersectPoint:Point = new Point();
			
			//RIGHT
			intersectPoint.x = _worldBounds.right;
			intersectPoint.y = _worldBounds.top+_worldBounds.height/2;
			if (!_touchingRight && rect.containsPoint(intersectPoint)){
				_touchingRight = true;
			}
			
			//LEFT
			intersectPoint.x = _worldBounds.left;
			intersectPoint.y = _worldBounds.top+_worldBounds.height/2;
			if (!_touchingLeft &&  rect.containsPoint(intersectPoint)){
				_touchingLeft = true;
			}
			
			//UP
			intersectPoint.x = _worldBounds.right-_worldBounds.width/2;
			intersectPoint.y = _worldBounds.top;
			if (rect.containsPoint(intersectPoint)){
				_touchingUp = true;
			}
			
			//DOWN
			intersectPoint.x = _worldBounds.right-_worldBounds.width/2;
			intersectPoint.y = _worldBounds.bottom;
			if (rect.containsPoint(intersectPoint)){
				_touchingDown = true;
				
			}
			
			if(unembed)
				unembedFromCollision(rect);
			
		}
		
		private function unembedFromCollision(collisionRect:Rectangle):void
		{
			var adjustment:Number;
			if (_touchingDown)
			{
				adjustment = collisionRect.top - _worldBounds.bottom;
				if(adjustment<1 && adjustment>-1){
					_entity.position.y += adjustment;
				}
			}else if (_touchingUp)
			{
				adjustment = collisionRect.bottom - _worldBounds.top;
				if(adjustment<1 && adjustment>-1){
					_entity.position.y += adjustment;
				}
			}
			if (_touchingRight)
			{
				adjustment = _worldBounds.right - collisionRect.left;
				if(adjustment<1 && adjustment>-1){
					_entity.position.x -= adjustment;
				}
			}
			if (_touchingLeft)
			{
				adjustment = _worldBounds.left - collisionRect.right;
				if(adjustment<1 && adjustment>-1){
					_entity.position.x -= adjustment;
				}
			}
		}
		
		override public function Destroy():void
		{
			entity.state.UnregisterCollider(this);
			super.Destroy();
		}
		
	}

}