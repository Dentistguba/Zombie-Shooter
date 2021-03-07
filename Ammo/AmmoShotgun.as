package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AmmoShotgun extends ammoPickup
	{
		private var ammo:int = 50;
		private var ammoType = BulletShotgun;
		
		public function AmmoShotgun():void 
		{
			super(ammo,ammoType);
		}
	}
}