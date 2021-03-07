package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class medFlame extends MovieClip
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private var speed:Number = 1;				//speed bullet moves
		private var flameDirection:Number = 0;	
		private var life:int = 20;

		
		public function medFlame(world,x,y,Direction):void 
		{
			this.WorldRef = world;
			stop();
			this.x = x;
			this.y = y;
			flameDirection = Direction;
			
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		//enter frame listener
		}
		
		public function loop(evt:Event):void
		{
			if (Engine.pauseGame == false)
			{
				y -= (Math.sin(flameDirection *Math.PI/180 +1.58) ) *speed;												
				x -= (Math.cos(flameDirection *Math.PI/180 +1.58) ) *speed;
				
				if (speed > 0)
				{
					speed -=0.05;
					this.scaleX -= 0.01;
					this.scaleY -= 0.01;
					
					if (speed <= 0.5)
					{
						gotoAndStop(2);
						alpha -=0.1;
					}
				}
				
				else 
				{
					removeEventListener(Event.ENTER_FRAME, loop);					
					
					if (WorldRef.contains(this))									//checks if bullet is in StageRef
						WorldRef.removeChild(this);	
				}
			}
		}
	}
}