package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Smg extends Gun
	{
		private const fireDelay:int = 100;
		private const accuracy = 10;
		private var sound = GUN03;
		private const clipSize = 10;
		private const reloadDelay = 1500;
		public const bulletType = Bullet9mm;
		
		public function Smg(world,holder,x,y):void
		{
			super(world,holder,x,y - this.height - 7,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay);
		}
	}
}