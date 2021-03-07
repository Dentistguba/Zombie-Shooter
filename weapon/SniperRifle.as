package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SniperRifle extends Gun
	{
		private const fireDelay:int = 300;
		private var accuracy = 2;
		private var sound = gunShot4;
		private const clipSize = 1;
		private const reloadDelay = 3000;
		public const bulletType = BulletSniper;
		
		public function SniperRifle(world,holder,x,y):void
		{
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay);
		}
	}
}