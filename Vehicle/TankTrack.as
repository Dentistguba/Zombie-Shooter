package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class TankTrack extends MovieClip
	{
		private var trackSectionList:Array
		private var bounds
		
		public function TankTrack()
		{
			bounds = 160 //height
			trackSectionList = new Array(trackSection1,trackSection2,trackSection3,trackSection4,trackSection5,trackSection6,trackSection7,trackSection8)
		}
		
		public function updatePos(amount):void
		{
			for (var i:int = 0; i < trackSectionList.length; i++)
			{
				trackSectionList[i].y -= amount;
				
				if (trackSectionList[i].y < -bounds/2)
					trackSectionList[i].y += bounds
					
				else if (trackSectionList[i].y > bounds/2)
					trackSectionList[i].y -= bounds
			}
		}
	}
}