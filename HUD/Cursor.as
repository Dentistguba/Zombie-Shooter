package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Cursor extends MovieClip
	{
		private var GameRef:Game;
		private var StageRef:Stage;
		
		public function Cursor(game,stageRef,x,y):void 
		{
			this.StageRef = stageRef;
			this.GameRef = game;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true); 			   //creates event listener(enter frame event, loop function below, false=, 0=priority, true=) 
		}
		
		private function loop(evt:Event):void
		{
			var MousePos:Point = GameRef.globalToLocal (new Point(StageRef.mouseX, StageRef.mouseY));
			
			this.x = MousePos.x;
			this.y = MousePos.y;
		}
	}
}