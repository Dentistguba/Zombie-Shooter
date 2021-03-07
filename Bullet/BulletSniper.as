package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BulletSniper extends Bullet
	{
		private var WorldRef:World;
		private var StageRef:Stage; 
		private const bulletSpeed:Number = 10;
		private var bulletDirection:Number = 0;	
		private var damage:int = 100;
		private var force:int = 1;
		
		public function BulletSniper(world,x,y,Direction):void 
		{
			super(world,x,y,Direction,bulletSpeed,damage,force,true,400);
		}
	}
}