package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class objectiveButton extends MovieClip
	{
		private var topic:String;
		
		public function objectiveButton(x,y,topic,Complete):void
		{
			stop();
			this.x = x;
			this.y = y;
			this.topic = topic;
			
			if (Complete == false)
				gotoAndStop (1);
				
			else if (Complete == true)
				gotoAndStop (2);
				
			subject.text = topic;
			
			
		}
	}
}