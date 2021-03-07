package
{
	import flash.events.Event;
	
	public class jeff extends NPC
	{
		private const Name:String = '';
		private const greeting:String = 'hi mate';
		private const greeting2:String = 'hi again';
		private const dangerGreeting:String = 'oh god!!';
		
		public function jeff():void
		{
			super(Name,greeting,greeting2,dangerGreeting);
			super.setGraphics(Head,Graphic,textBox,hitBox);
			topicList = new Array (new Array("what is happening?","i don't know, people just started attacking each other"),new Array('who are you?',"i am jeff"),new Array('your mum',"fuck you"));
		}
	}
}