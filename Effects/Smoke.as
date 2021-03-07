package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class Smoke extends MovieClip
	{
		private var WorldRef:World;
		private var ydir;
		private var xdir; 
		private var smokeLife:Timer = new Timer(1000,1); 
		
		public function Smoke(world, x, y) :void		//builder
		{
			this.WorldRef = world;											
			this.x = x;
			this.y = y;
			
			smokeLife.addEventListener("timer", this.removeSelf);
			smokeLife.start();
			
			ydir = Math.random() -0.5;
			xdir = Math.random() -0.5;
			
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		private function loop (evt:Event):void
		{
			if (Engine.pauseGame == false)
			{
			y += ydir;
			x += xdir;			
			}
		}
		
		private function removeSelf(evt:Event):void									
		{
			removeEventListener(Event.ENTER_FRAME, loop);					
			
			if (WorldRef.contains(this))									
				WorldRef.removeChild(this);									
		}
		
		
	}
}