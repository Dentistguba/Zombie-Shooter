package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Ammo9mm extends ammoPickup
	{
		private var ammo:int = 50;
		private var ammoType = Bullet9mm;
		
		public function Ammo9mm():void 
		{
			super(ammo,ammoType);
		}
	}
}