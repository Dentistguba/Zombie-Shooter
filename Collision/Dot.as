package
{
	import flash.display.Stage
	import flash.events.Event
	import flash.display.MovieClip
	
	public class Dot extends MovieClip
	{
		public function Dot(x = null,y = null)
		{
			if (x != null && y != null)
			{
				this.x = x;
				this.y = y;
			}
		}
	}
}