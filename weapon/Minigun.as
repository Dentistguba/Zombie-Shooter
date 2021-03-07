package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Minigun extends Gun
	{
		private const fireDelay:int = 20;
		public const bulletType = TracerBullet;
		private const accuracy = 30;
		private var sound = GUN02;
		private const clipSize = 0;
		private const reloadDelay = 10;
		
		public function Minigun(world,holder,x,y):void
		{
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay);
		}
	}
}