package org.kss.helpers 
{
	/**
	 * ...
	 * @author Matt
	 */
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
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
		
		public function KSSInput(stage:Stage) 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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