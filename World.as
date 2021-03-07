package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class World extends MovieClip
	{
		private var StageRef:Stage;	
		
		// used for camera object follow
		public var target;
		
		public var night:Boolean = false;
		public var hourChangeCountdown:int = 20;
		
		// used for camera mouse follow
		public var mouseFollow = false;
		private var mousePos:Point;
		
		public function World(stageRef:Stage):void
		{
			mouseChildren = false
			mouseEnabled = false
			
			this.StageRef = stage;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true); 			   //creates event listener(enter frame event, loop function below, false=, 0=priority, true=) 
			
			//mask = darkness.darknessMask;
		}
		
		public function setCamTarget(target):void
		{
			this.target = target; 
		}
		
		// moves world to center target object
		public function camMove():void
		{
			if (this.target != null)
			{
				this.x = (this.width / 2) - this.target.x - ((this.width) / 2);
				this.y = (this.height / 2) - this.target.y - ((this.height) / 2);
			}
		}
		
		private function loop(evt:Event):void
		{
			if (night && darkness.darknessMask.daylight.alpha < 1 && hourChangeCountdown <= 0)
			{
				hourChangeCountdown = 20;
				
				darkness.darknessMask.daylight.alpha += 0.1
				//darkness.darknessMask.daylight.alpha += 0.005
				
				
				lightLayer.alpha = 1-darkness.darknessMask.daylight.alpha
				Engine.player.light.alpha = 1-darkness.darknessMask.daylight.alpha
			}
			
			else if (night)
			{
				hourChangeCountdown --;
				night = false;
			}
			
			else if (night == false && darkness.darknessMask.daylight.alpha > 0  && hourChangeCountdown <= 0)
			{
				hourChangeCountdown = 20;
				
				darkness.darknessMask.daylight.alpha -= 0.1
				//darkness.darknessMask.daylight.alpha -= 0.005
				
				lightLayer.alpha = 1-darkness.darknessMask.daylight.alpha
				Engine.player.light.alpha = 1-darkness.darknessMask.daylight.alpha
			}
			
			else 
			{
				hourChangeCountdown --;
				
				if (night == false)
					night = true;
			}
			
			
			// moves world to center mouse pointer
			if (mouseFollow == true)
			{
				mousePos = globalToLocal (new Point(StageRef.mouseX, StageRef.mouseY));
				this.x = (this.width / 2) - mousePos.x - ((this.width) / 2);
				this.y = (this.height / 2) - mousePos.y - ((this.height) / 2);
			}
			
			// moves world to center target object
			else if (this.target != null)
			{
				this.x = (this.width / 2) - this.target.x - ((this.width) / 2);
				this.y = (this.height / 2) - this.target.y - ((this.height) / 2);
			}

			else
				this.target = Engine.player;
		}
	}
}