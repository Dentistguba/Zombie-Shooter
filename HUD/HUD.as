package
{
	import flash.display.Stage;
	import flash.display.MovieClip;	
	import flash.events.Event;
	
	public class HUD extends MovieClip
	{
		private var ammo:String = '0';
		private var life:String = '0';
		private var clip:String = '0';
		
		public function HUD(x,y,player):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function UpdateAmmo(playerAmmo):void
		{
			ammo = playerAmmo;
		}
		
		public function UpdateClip(playerClip):void
		{
			clip = playerClip;
		}
		
		public function UpdateLife(playerLife):void
		{
			life = playerLife;
		}
		
		public function UpdateDisplay():void
		{
			Ammo.text = ammo;
			Clip.text = clip;
			Life.text = life;
			//shieldBar.scaleX = player.getShield();
		}
		
	}
}