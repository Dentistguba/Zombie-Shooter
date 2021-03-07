package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	
	public class ammoPickup extends MovieClip
	{
		private var ammoType = Bullet9mm;
		private var ammo:int = 10;
		private var respawnTime:Timer = new Timer(10000,1);
		private var empty:Boolean = false;
		
		public function ammoPickup(ammo,ammoType) :void		//builder
		{
			this.ammo = ammo;
			this.ammoType = ammoType;
			respawnTime.addEventListener("timer", this.respawn);
			Engine.ammoList.push(this);
		}
		
		public function giveAmmo(target):void
		{
			if (empty == false)
			{
				target.ammoList[ammoType] += ammo;
				empty = true;
				respawnTime.start();
				alpha = 0;
			}
		}
		
		private function respawn(evt:Event):void
		{
			empty = false;
			alpha = 100;
		}
		
		private function removeSelf(evt:Event):void									
		{			
			if (parent.contains(this))									
				parent.removeChild(this);									
		}
		
		
	}
}