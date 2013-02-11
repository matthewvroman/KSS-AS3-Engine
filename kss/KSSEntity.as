package org.kss 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.kss.KSSComponent;
	import org.kss.KSSObject;
	import org.kss.KSSState;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSEntity extends KSSObject
	{
		protected var _state:KSSState;	
		public function get state():KSSState { return _state; }
		private var _components:Vector.<KSSComponent> = new Vector.<KSSComponent>();
		private var _numComponents:int = 0;
		
		private var _position:Point = new Point(0, 0);
		public function get position():Point { return _position; }
		public function set position(point:Point):void { _position = point; }
		
		public function KSSEntity(state:KSSState) 
		{
			_state = state;
			super();
		}
		
		public function AddComponent(component:KSSComponent):*
		{
			_components.push(component);
			_numComponents = _components.length;
			
			return component;
		}
		
		public function RemoveComponent(component:KSSComponent):Boolean
		{
			var idx:int = _components.indexOf(component);
			if (idx != -1)
			{
				component.Destroy();
				_components.splice(idx, 1);
				_numComponents = _components.length;
				return true;
			}
			return false;
		}
		
		public function GetComponentOfType(type:Class):*
		{
			var length:int = _components.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_components[i] is type)
				{
					return _components[i];
				}
			}
			
			return null;
		}
		
		public function GetComponentsOfType(type:Class):Vector.<*>
		{
			var classComponents:Vector.<*> = new Vector.<*>();
			
			for (var i:int = 0; i < _numComponents; i++)
			{
				if (_components[i] is type)
				{
					classComponents.push(_components[i]);
				}
			}
			
			if (classComponents.length > 0)
				return classComponents;
				
			return null;
		}
		
		override public function PreUpdate():void
		{
			if (!active) return;
			
			super.PreUpdate();
			for (var i:int = 0; i < _components.length; i++)
			{
				_components[i].PreUpdate();
			}
		}
		
		override public function Update():void
		{
			if (!active) return;
			
			super.Update();
			for (var i:int = 0; i < _components.length; i++)
			{
				_components[i].Update();
			}
		}
		
		override public function LateUpdate():void
		{
			if (!active) return;
			
			super.LateUpdate();
			for (var i:int = 0; i < _components.length; i++)
			{
				_components[i].LateUpdate();
			}
		}
		
		//TODO: THIS
		public function SendMessage(message:String, receiver:KSSEntity):Boolean
		{
			return false;
		}
		//TODO: THIS
		public function ReceiveMessage(message:String, sender:KSSEntity):Boolean
		{
			return true; //got the message
		}
		
		//determine if we're visible in the current camera
		public function get offscreen():Boolean
		{
			return !state.Canvas.currentCamera.frame.containsPoint(_position);
		}
		
		
		override public function Destroy():void
		{
			super.Destroy();
			while (_components.length > 0)
			{
				var component:KSSComponent = _components.pop();
				component.Destroy();
			}
		}
		
	}

}