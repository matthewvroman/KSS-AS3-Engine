package org.kss.helpers 
{
	/**
	 * ...
	 * @author Matt
	 */
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.kss.KSSEngine;
	
	public class KSSInput 
	{
		public static var W:uint = 119;
		public static var A:uint = 97;
		public static var S:uint = 115;
		public static var D:uint = 100;
		public static var SPACEBAR:uint = 32;
		
		private static var keysDownThisFrame:Vector.<uint> = new Vector.<uint>();
		private static var keysReleasedThisFrame:Vector.<uint> = new Vector.<uint>();
		private static var keysPressedThisFrame:Vector.<uint> = new Vector.<uint>();
		
		private static var _mousePosition:Point = new Point();
		public static function get MousePosition():Point { return _mousePosition; } 
		
		private static var _mouseDown:Boolean = false;
		public static function get MouseDown():Boolean { return _mouseDown; }
		
		private static var _mouseClicked:Boolean = false;
		public static function get MouseClicked():Boolean { return _mouseClicked; }
		
		public function KSSInput(stage:Stage) 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			_mouseClicked = true;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_mouseDown = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			_mousePosition.x = e.stageX/KSSEngine.StageScale;
			_mousePosition.y = e.stageY/KSSEngine.StageScale;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			//trace("Key down: " + e.charCode);
			var index:int;
			
			index = keysPressedThisFrame.indexOf(e.charCode);
			if (index==-1 && keysDownThisFrame.indexOf(e.charCode)==-1){
				keysPressedThisFrame.push(e.charCode);
			}
			
			index = keysDownThisFrame.indexOf(e.charCode)
			if (index==-1)
			{
				keysDownThisFrame.push(e.charCode);
			}
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			//trace("Key up: " + e.charCode);
			
			keysReleasedThisFrame.push(e.charCode);
			//remove from other vectors if it exists
			var index:int;
			index = keysDownThisFrame.indexOf(e.charCode)
			if (index!=-1)
			{
				keysDownThisFrame.splice(index, 1);
			}
			
			index = keysPressedThisFrame.indexOf(e.charCode)
			if (index != -1)
			{
				keysPressedThisFrame.splice(index, 1);
			}
		}
		//called by KSSEngine after all Update loops are done
		public function flush():void
		{
			keysReleasedThisFrame.length = 0;
			keysPressedThisFrame.length = 0;
			
			_mouseClicked = false;
		}
		
		public static function isKeyDown(key:uint):Boolean
		{
			var index:int = keysDownThisFrame.indexOf(key)
			if (index != -1)
			{
				return true;
			}
			
			return false;
		}
		
		public static function isKeyUp(key:uint):Boolean
		{
			var index:int = keysReleasedThisFrame.indexOf(key)
			if (index != -1)
			{
				return true;
			}
			
			return false;
		}
		
		public static function isKeyPressed(key:uint):Boolean
		{
			var index:int = keysPressedThisFrame.indexOf(key)
			if (index != -1)
			{
				return true;
			}
			
			return false;
		}
		
	}

}