package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Spawn extends MovieClip
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private const maxZombies:int = 500;
		private var zombNumber = 0;
		private var position:Point;
		private var addedAsChild:Boolean = false;
		
		public function Spawn(StageRef:Stage,world:World, x, y):void 
		{	
			this.x = x;
			this.y = y;
			this.WorldRef = world;
			this.StageRef = StageRef;
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true); 			   //creates event listener(enter frame event, loop function below, false=, 0=priority, true=) 
			addEventListener(Event.ADDED, isChild, false, 0, true);
		}
		
		private function isChild(evt:Event):void
		{
			addedAsChild = true;
			removeEventListener(Event.ADDED, isChild);
		}
		
		private function loop(evt:Event):void
		{
			// adds zombies to world out of view of player
			if (zombNumber < maxZombies)
			{
				position = new Point(Math.random()*WorldRef.worldBoundary.width,Math.random()*WorldRef.worldBoundary.height)
				if (((position.x + (180) < Engine.player.x || position.x - (180) > Engine.player.x) && (position.y + (180) < Engine.player.y || position.y - (180) > Engine.player.y)))
					WorldRef.addChildAt (new Enemy(WorldRef,position.x,position.y),WorldRef.getChildIndex(Engine.player) - 1);
					
				zombNumber ++;
			}
			
		}
	}
}