package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AmmoFlame extends ammoPickup
	{
		private var ammo:int = 50;
		private var ammoType = Flame;
		
		public function AmmoFlame():void 
		{
			super(ammo,ammoType);
		}
	}
}