package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	public class areaObjective extends Object
	{
		public var Name:String;
		public var Location:Rectangle;
		public var Constant:Boolean = false;
		public var Complete:Boolean = false;
		
		public function areaObjective(Name:String, Location:Rectangle, Constant = false):void
		{
			this.Name = Name;
			this.Location = Location;
			this.Constant = Constant;
		}
		
		public function checkComplete():void
		{
			if (Engine.player.x >= Location.x && Engine.player.x <= Location.right && Engine.player.y >= Location.y && Engine.player.y <= Location.bottom)
			{
				Complete = true;
			}
			
			else if (Constant == true)
			{
				Complete = false;
			}
		}
	}
}