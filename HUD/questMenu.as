package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class questMenu extends MovieClip
	{
		private var questList:Array;

		private var questButtonList:Array;
		private var objectiveButtonList:Array;
		
		private var spacing:int = 30;
		private var startPoint:Point = new Point (100,-150);
		
		private var objectiveSpacing:int = 20;
		private var objectiveStartPoint:Point = new Point (-200,-50);
		
		public function questMenu():void
		{
		}
		
		public function fillMenu(quests):void
		{
			info.text = '';
			questButtonList = new Array;
			objectiveButtonList = new Array;
			questList = quests;
			
			for (var i:int = 0; i < questList.length; i++)
			{
				if (questList[i] != null)
					questButtonList.push(addChild (new speechButton(startPoint.x,startPoint.y + (spacing * i),questList[i].Name)))
			}
		}
		
		public function checkClick():void
		{
			//trace(topicList);
			var globalButtonPos:Point;
			
			for (var i:int = 0; i < questButtonList.length; i++)
			{
				globalButtonPos = localToGlobal(new Point(questButtonList[i].x,questButtonList[i].y))
				
				if (stage.mouseX > globalButtonPos.x && stage.mouseX < globalButtonPos.x + (questButtonList[i].width) && stage.mouseY > globalButtonPos.y && stage.mouseY < globalButtonPos.y + (questButtonList[i].height))
				{
					for (var m:int = 0; m < objectiveButtonList.length; m++)
					{
						removeChild(objectiveButtonList[m]);
					}
					objectiveButtonList.splice(0,objectiveButtonList.length);
					
					Name.text = questList[i].Name;
					
					trace('button click');
					info.text = questList[i].Description;
					
					if (questList[i].objectiveList != null)
					{
						for (var o:int = 0; o < questList[i].objectiveList.length; o++)
						{
							//if (questList[i].objectiveList[o] != null)
							objectiveButtonList.push(addChild (new objectiveButton(objectiveStartPoint.x,objectiveStartPoint.y + (objectiveSpacing * o),questList[i].objectiveList[o].Name,questList[i].objectiveList[o].Complete)))
						}
					}
				}
			}
		}
	
		public function clearMenu():void
		{
			for (var i:int = 0; i < questButtonList.length; i++)
			{
				questButtonList[i].removeSelf();
				removeChild(questButtonList[i]);
				questButtonList.splice(i,1);
			}
			
			for (var i:int = 0; i < objectiveButtonList.length; i++)
			{
				removeChild(objectiveButtonList[i]);
				objectiveButtonList.splice(i,1);
			}
			
			//topicList.splice(0,topicList.length)
		}
	}
}