package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AmmoSniper extends ammoPickup
	{
		private var ammo:int = 50;
		private var ammoType = BulletSniper;
		
		public function AmmoSniper():void 
		{
			super(ammo,ammoType);
		}
	}
}