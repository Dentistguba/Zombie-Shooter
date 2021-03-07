package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class zombBlood extends MovieClip
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private var speed:Number = 6;				//speed bullet moves
		private var bloodDirection:Number = 0;	
		private var life:int = 100;

		
		public function zombBlood(world,x,y,Direction,Rotation):void 
		{
			this.WorldRef = world;
			stop();
			this.x = x;
			this.y = y;
			bloodDirection = Direction;
			this.rotation = Rotation;
			
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		//enter frame listener
		}
		
		public function loop(evt:Event):void
		{
			y -= (Math.sin(bloodDirection *Math.PI/180 +1.58) ) *speed;												
			x -= (Math.cos(bloodDirection *Math.PI/180 +1.58) ) *speed;
			
			if (speed > 0)
			{
				speed -=1;
				this.scaleX += 0.1;
				this.scaleY += 0.1;
			}
			
			else 
			{
				gotoAndStop(2);
				if (life > 0)
				{
					this.alpha -=0.01;
					life --;
				}
				
				else
				{
					if (WorldRef.contains(this))									//checks if bullet is in StageRef
						WorldRef.removeChild(this);	
				
					removeEventListener (Event.ENTER_FRAME, loop);
				}
			}
		}
	}
}