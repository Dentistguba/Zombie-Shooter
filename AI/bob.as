package
{
	import flash.events.Event;
	import flash.utils.Dictionary;	
	
	public class bob extends NPC
	{
		private const Name:String = '';
		private const greeting:String = 'howdy';
		private const greeting2:String = "ah, it's you";
		private const dangerGreeting:String = 'aaaaaaa';
		private const weaponlist:Array = new Array(Smg);
		private const ammolist:Dictionary = new Dictionary();
		
		public function bob():void
		{
			super(Name,greeting,greeting2,dangerGreeting);
			
			ammolist[Bullet9mm] = int.MAX_VALUE;
			
			super.setGraphics(Head,Graphic,textBox,hitBox,weaponlist,ammolist);
			
			topicList = new Array (new Array("what is happening?","i think they're filmin one of them zombie flicks"),new Array('who are you?',"i am bob, i'm a cattle rancher. moved to the big city last week"),new Array('how did this happen',"i reckon it's them commies again"));
		}
	}
}