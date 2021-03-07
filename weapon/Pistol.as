package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Pistol extends Gun
	{
		private const fireDelay:int = 300;
		private var accuracy = 2;
		private const bulletNo:int = 1;
		private var sound = gunShot;
		private const clipSize = 10;
		private const reloadDelay = 1500;
		public const bulletType = Bullet9mm;
		
		public function Pistol(world,holder,x,y):void
		{
			stop();
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay,bulletNo);
		}
	}
}