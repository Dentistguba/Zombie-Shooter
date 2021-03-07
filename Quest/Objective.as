package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Objective extends Object
	{
		public var Name:String;
		public var requirement:String;
		public var optional:Boolean = false;
		public var Complete:Boolean = false;
		
		public function Objective(Name, requirement,optional = false):void
		{
			this.Name = Name;
			this.requirement = requirement;
			this.optional = optional;
		}
		
		public function checkComplete():void
		{
			
		}
	}
}