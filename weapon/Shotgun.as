package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Shotgun extends Gun
	{
		private const fireDelay:int = 1000;
		private var accuracy = 30;
		private const bulletNo:int = 5;
		private var sound = shotgunSound;
		private const clipSize = 10;
		private const reloadDelay = 3000;
		public const bulletType = BulletShotgun;
		
		public function Shotgun(world,holder,x,y):void
		{
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay,bulletNo);
		}
	}
}