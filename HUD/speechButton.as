package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class speechButton extends MovieClip
	{
		private var topic:String;
		
		public function speechButton(x,y,topic):void
		{
			stop();
			this.x = x;
			this.y = y;
			this.topic = topic;
			subject.text = topic;
			
			addEventListener (MouseEvent.ROLL_OVER, this.mouseover);
			addEventListener (MouseEvent.ROLL_OUT, this.mouseoff);
		}
		
		private function mouseover(evt:MouseEvent)
		{
			gotoAndStop (2);
			subject.text = topic;
		}
		
		private function mouseoff(evt:MouseEvent)
		{
			gotoAndStop (1);
			subject.text = topic;
		}
		
		public function removeSelf():void
		{
			removeEventListener (MouseEvent.MOUSE_OVER, this.mouseover);
			removeEventListener (MouseEvent.MOUSE_OUT, this.mouseoff);
		}
	}
}