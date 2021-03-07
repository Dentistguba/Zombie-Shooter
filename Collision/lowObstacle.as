package
{
	import flash.display.Stage
	import flash.events.Event
	import flash.display.MovieClip
	import flash.geom.Point;
	
	public class lowObstacle extends MovieClip
	{
		public var point1; 
		public var point2;
		public var point3;
		public var point4;
		public var pointList:Array = new Array();
		
		public function lowObstacle()
		{
			Engine.lowObstacleList.push (this);
		}
		
		public function createCorners(world):void
		{
			var cornerPos:Point = world.globalToLocal(localToGlobal(new Point (-width/2,-height/2)));
	
			pointList.push(world.addChild(point1 = new Dot(cornerPos.x,cornerPos.y)));
			
			cornerPos = world.globalToLocal(localToGlobal(new Point (width/2,-height/2)));
			
			pointList.push(world.addChild(point2 = new Dot(cornerPos.x,cornerPos.y)));
			
			cornerPos = world.globalToLocal(localToGlobal(new Point (-width/2,height/2)));
			
			pointList.push(world.addChild(point3 = new Dot(cornerPos.x,cornerPos.y)));
			
			cornerPos = world.globalToLocal(localToGlobal(new Point (width/2,height/2)));
			
			pointList.push(world.addChild(point3 = new Dot(cornerPos.x,cornerPos.y)));
		}
	}
}