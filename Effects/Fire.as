package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.BlendMode;
	
	public class Fire extends MovieClip
	{
		private var WorldRef:World;
		public var life:int = 100;
		private var lightMaskRef;
		
		public function Fire(world,x,y):void
		{
			lightMaskRef = lightMask;
			Engine.fireList.push(this);
			WorldRef = world;
			this.x = x;
			this.y = y;
			WorldRef.darkness.darknessMask.addChild(lightMask)
			lightMask.x = x;
			lightMask.y = y;
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		//enter frame listener
		}
		
		private function loop(evt:Event):void
		{
			if (Engine.pauseGame == false)
			{
			for (var i:int = 0; i < Engine.enemyList.length; i++)
			{
				if (hitTestObject(Engine.enemyList[i]))
				{
					Engine.enemyList[i].onFire = 80;
				}
			}

			
			var flamey = WorldRef.addChildAt (new medFlame(WorldRef,x + ((Math.random()-0.5) * 42) ,y + ((Math.random()-0.5) * 42),Math.random()*360),1);
			flamey.blendMode = BlendMode.ADD
			
			life --;
			
			if (life <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, loop);					//remove listener

				WorldRef.darkness.darknessMask.removeChild(lightMask)

				if (WorldRef.contains(this))									//checks if bullet is in StageRef
					WorldRef.removeChild(this);									
			}
			}
		}
	}
}