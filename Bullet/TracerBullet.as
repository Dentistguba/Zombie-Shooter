package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TracerBullet extends Bullet
	{
		private var WorldRef:World;
		private var StageRef:Stage; 
		private const bulletSpeed:Number = 8;
		private var bulletDirection:Number = 0;	
		public const damage:int = 10;
		private var force:int = 1;
		
		public function TracerBullet(world,x,y,Direction):void 
		{
			super(world,x,y,Direction,bulletSpeed,damage,force);
		}
	}
}