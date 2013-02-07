package org.kss.components 
{
	import flash.geom.Point;
	import org.kss.KSSComponent;
	import org.kss.KSSEntity;
	import org.kss.KSSEngine;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSPhysics extends KSSComponent
	{
		public var velocity:Point = new Point();
		public var maxVelocity:Point = new Point(10000,10000);
		public var acceleration:Point=new Point();
		public var maxAcceleration:Number;
		public var drag:Point = new Point(); //y
		public var gravity:Point= new Point();
		
		public function KSSPhysics(e:KSSEntity) 
		{
			super(e);
			
		}
		
		override public function LateUpdate():void
		{
			super.LateUpdate();
			updateMotion();
		}
		
		protected function updateMotion():void
		{
			var delta:Number;
			var velocityDelta:Number;
			
			velocityDelta = (computeVelocity(velocity.x,acceleration.x,drag.x,maxVelocity.x) - velocity.x)/2;
			velocity.x += velocityDelta;
			delta = velocity.x*KSSEngine.deltaTime;
			velocity.x += velocityDelta;
			_entity.position.x += delta;
			

			velocityDelta = (computeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y) - velocity.y) / 2;

			velocity.y += velocityDelta;
			delta = velocity.y*KSSEngine.deltaTime;
			velocity.y += velocityDelta;
			_entity.position.y += delta;
		}
		
		public function computeVelocity(Velocity:Number, Acceleration:Number=0, Drag:Number=0, Max:Number=10000):Number
		{
			if(Acceleration != 0)
				Velocity += Acceleration*KSSEngine.deltaTime;
			else if(Drag != 0)
			{
				var drag:Number = Drag * KSSEngine.deltaTime;
				if(Velocity - drag > 0)
					Velocity = Velocity - drag;
				else if(Velocity + drag < 0)
					Velocity += drag;
				else
					Velocity = 0;
			}
			if((Velocity != 0) && (Max != 10000))
			{
				if(Velocity > Max)
					Velocity = Max;
				else if(Velocity < -Max)
					Velocity = -Max;
			}
			return Velocity;
		}
		
	}

}