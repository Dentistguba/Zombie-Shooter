package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AmmoMinigun extends ammoPickup
	{
		private var ammo:int = 50;
		private var ammoType = TracerBullet;
		
		public function AmmoMinigun():void 
		{
			super(ammo,ammoType);
		}
	}
}