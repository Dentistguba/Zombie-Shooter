package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	public class speechMenu extends MovieClip
	{
		private var topicList:Array;
		private var questList:Array;
		
		private var topicButtonList:Array;
		private var questButtonList:Array;
		
		private var currentQuest;

		private var spacing:int = 30;
		private var startPoint:Point = new Point (100,-150);
		
		public function speechMenu():void
		{
		}
		
		public function fillMenu(target):void
		{
			replyBox.text = '';
			topicList = target.topicList;
			topicButtonList = new Array;
			questButtonList = new Array;
			questList = target.questList;
			
			for (var i:int = 0; i < target.topicList.length; i++)
			{
				topicButtonList.push(addChild (new speechButton(startPoint.x,startPoint.y + (spacing * i),target.topicList[i][0])))
			}
			
			for (var i:int = 0; i < questList.length; i++)
			{
				if (questList[i] != null)
					questButtonList.push(addChild (new speechButton(startPoint.x,startPoint.y + (spacing  * (i + topicList.length)),questList[i].initName)))
			}
		}
		
		public function checkClick():void
		{
			//trace(topicList);
			var globalButtonPos:Point;
			
			for (var i:int = 0; i < topicButtonList.length; i++)
			{
				globalButtonPos = localToGlobal(new Point(topicButtonList[i].x,topicButtonList[i].y))
				
				if (stage.mouseX > globalButtonPos.x && stage.mouseX < globalButtonPos.x + (topicButtonList[i].width) && stage.mouseY > globalButtonPos.y && stage.mouseY < globalButtonPos.y + (topicButtonList[i].height))
				{
					trace('button click');
					replyBox.text = topicList[i][1];
					accept.alpha = 0;
				}
			}
			
			for (var i:int = 0; i < questButtonList.length; i++)
			{
				globalButtonPos = localToGlobal(new Point(questButtonList[i].x,questButtonList[i].y))
				
				if (stage.mouseX > globalButtonPos.x && stage.mouseX < globalButtonPos.x + (questButtonList[i].width) && stage.mouseY > globalButtonPos.y && stage.mouseY < globalButtonPos.y + (questButtonList[i].height))
				{
					accept.alpha = 0;
					
					trace('button click');
					if (questList[i].inProgress == false)
					{
						replyBox.text = questList[i].initDescription;
						currentQuest = questList[i];
						accept.alpha = 100;
						decline.alpha = 100;
					}
					
					else 
					{
						replyBox.text = questList[i].inProgressText;
					}
				}
			}
			
			globalButtonPos = localToGlobal(new Point(accept.x,accept.y))
			
			if (accept.alpha == 100 && stage.mouseX > globalButtonPos.x && stage.mouseX < globalButtonPos.x + (accept.width) && stage.mouseY > globalButtonPos.y && stage.mouseY < globalButtonPos.y + (accept.height))
			{
				trace('button click');
				if (currentQuest.inProgress == false)
				{
					currentQuest.inProgress = true;
					Engine.player.questList.push(currentQuest);
					trace (Engine.player.questList);
					replyBox.text = currentQuest.acceptText;
					accept.alpha = 0;
					decline.alpha = 0;
				}
			}
			
			globalButtonPos = localToGlobal(new Point(decline.x,decline.y))
			
			if (decline.alpha == 100 && stage.mouseX > globalButtonPos.x && stage.mouseX < globalButtonPos.x + (decline.width) && stage.mouseY > globalButtonPos.y && stage.mouseY < globalButtonPos.y + (decline.height))
			{
				replyBox.text = currentQuest.declineText;
				accept.alpha = 0;
				decline.alpha = 0;
			}
			
		}
	
		public function clearMenu():void
		{
			for (var i:int = 0; i < topicButtonList.length; i++)
			{
				topicButtonList[i].removeSelf();
				removeChild(topicButtonList[i]);
				topicButtonList.splice(i,1);
			}
			
			for (var i:int = 0; i < questButtonList.length; i++)
			{
				questButtonList[i].removeSelf();
				removeChild(questButtonList[i]);
				questButtonList.splice(i,1);
			}
			
			//topicList.splice(0,topicList.length)
		}
	}
}