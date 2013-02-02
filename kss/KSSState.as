package org.kss 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		public function KSSState(engine:KSSEngine) 
		{
			_engine = engine;
			_canvas = _engine.WriteCanvas;
			super();
			
		}
		
		override public function Awake():void
		{

		}
		
		override public function LateUpdate():void
		{
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