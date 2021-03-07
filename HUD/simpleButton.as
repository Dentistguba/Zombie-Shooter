package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class simpleButton extends MovieClip
	{
		public function simpleButton():void
		{
			stop();
			
			addEventListener (MouseEvent.MOUSE_OVER, this.mouseover);
			addEventListener (MouseEvent.MOUSE_OUT, this.mouseoff);
		}
		
		private function mouseover(evt:MouseEvent)
		{
			gotoAndStop (2);
		}
		
		private function mouseoff(evt:MouseEvent)
		{
			gotoAndStop (1);
		}
		
		public function removeSelf():void
		{
			removeEventListener (MouseEvent.MOUSE_OVER, this.mouseover);
			removeEventListener (MouseEvent.MOUSE_OUT, this.mouseoff);
		}
	}
}