package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Bullet50Cal extends Bullet
	{
		private var WorldRef:World;
		private var StageRef:Stage; 
		private const bulletSpeed:Number = 8;
		private var bulletDirection:Number = 0;	
		private var damage:int = 25;
		private var force:int = 1;
		
		public function Bullet50Cal(world,x,y,Direction):void 
		{
			super(world,x,y,Direction,bulletSpeed,damage,force);
		}
	}
}