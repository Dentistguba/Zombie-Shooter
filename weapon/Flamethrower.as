package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Flamethrower extends Gun
	{
		private const fireDelay:int = 0;
		private const accuracy:int = 10;
		private const clipSize = 0;
		private const reloadDelay = 1;
		public const bulletType = Flame;
		
		private var sound = fireLoop;
		private var soundStart:Boolean = true;
		private var soundComplete:Boolean = false;		
		
		public function Flamethrower(world,holder,x,y):void
		{
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay);
		}
		
		override public function endFire():void
		{
			soundChannel.stop();
			soundStart = true;
		}
		
		override public function fire():void
		{
			if (canFire == true && Holder.ammoList[bulletType] > 0)
			{
				Position = WorldRef.globalToLocal(localToGlobal(new Point(x,y + 15)));
				WorldRef.addChild (new bulletType(WorldRef,Position.x, Position.y, Holder.Graphic.rotation + ((Math.random() -0.5) * accuracy) ));		//creates bullet 1
				WorldRef.addChild (new Smoke(WorldRef,Position.x, Position.y));
				//ammo --;
				Holder.ammoList[bulletType] --;
				
				if (soundStart == true)
				{
					soundChannel = fireSound.play(0,int.MAX_VALUE);
					soundStart = false;
				}
					
				canFire = false;
				fireDelayTimer.start();
			}
		}
	}
}