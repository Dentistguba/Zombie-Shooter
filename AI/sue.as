package
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class sue extends NPC
	{
		private const Name:String = '';
		private const greeting:String = 'oh thank god, thought there was noone left';
		private const greeting2:String = 'you again';
		private const dangerGreeting:String = 'fffffuuuuuuuuck';
		
		public function sue():void
		{
			super(Name,greeting,greeting2,dangerGreeting);
			super.setGraphics(Head,Graphic,textBox,hitBox);
			topicList = new Array (new Array("what is going on?","these c.. c... creatures came out of nowhere, i could swear one of them looked like my boss"),new Array('who are you?',"i am sue, i work in this office, when it isn't overrun with the undead ☺"),new Array('anything useful here?',"there's some ammo in the bathroom, no idea why"));
			questList = new Array (new Quest("my boss","sue's boss","help me find my boss. I hope nothing's happened to him, the last thing you want is to be unemployed during the zombie apocalypse","help sue find her boss","have you found him?",new Array(new Objective("find sue's boss","blah"),new Objective("inform sue","blah"))));
			questList.push(new Quest("supplies","going shopping","maybe you could get me some food","find food for sue","found any yet?",new Array(new areaObjective("find a shop",new Rectangle(2008.6,611.85,374.95,336.95),true))));
			trace (questList);
		}
	}
}