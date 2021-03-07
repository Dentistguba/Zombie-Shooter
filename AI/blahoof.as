package
{
	import flash.events.Event;
	import flash.utils.Dictionary;	
	
	public class blahoof extends NPC
	{
		private const Name:String = '';
		private const greeting:String = "lovely weather isn't it";
		private const greeting2:String = "kill any zombies lately";
		private const dangerGreeting:String = 'you shall not get the better of me';
		private const weaponlist:Array = new Array(Flamethrower);
		private const ammolist:Dictionary = new Dictionary();
		
		public function blahoof():void
		{
			super(Name,greeting,greeting2,dangerGreeting);
			
			ammolist[Flame] = int.MAX_VALUE;
			
			super.setGraphics(Head,Graphic,textBox,hitBox,weaponlist,ammolist);
			
			topicList = new Array (new Array("what is happening?","i do believe this is the archetypal zombie apocalypse sir"),new Array('who are you?',"blahoof at your service"),new Array('how did this happen',"triggered by the lack of respect for the old ways i should think"));
		}
	}
}