package org.kss.animation 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSAnimationFrame 
	{
		public var rect:Rectangle;
		public var label:String;
		public var position:int;
		
		public function KSSAnimationFrame(frameRect:Rectangle,frameLabel:String="",framePosition:int=-1) 
		{
			rect = frameRect;
			label = frameLabel;
			position = framePosition;
		}
		
	}

}