package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class Quest extends Object
	{
		public var owner;
		public var initName:String = 'generic quest';
		public var Name:String = 'generic quest';
		public var initDescription:String = 'genericness';
		public var Description:String = 'genericness';
		public var acceptText:String = 'good luck';
		public var declineText:String = 'oh well, maybe another time then';
		public var inProgressText:String = 'any luck with that yet';
		public var inProgress:Boolean = false;
		public var objectiveList:Array;
		
		public function Quest(initName:String,Name:String,initDescription:String,Description:String,inProgressText:String,objectives:Array = null):void
		{
			this.initName = initName;
			this.Name = Name;
			this.initDescription = initDescription;
			this.Description = Description;
			this.inProgressText = inProgressText;
			
			if (objectives != null)
				this.objectiveList = objectives;
				
			//objectiveList.push(new Objective('Obstacle'));
		}
		
		public function checkComplete():void
		{
			for (var i:int = 0; i < objectiveList.length; i++)
			{
				objectiveList[i].checkComplete();
			}
		}
		
	}
}