package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class ShellCasing extends MovieClip
	{
		private var WorldRef:World;
		private var StageRef:Stage;
		private var shellCasingSpeed:Number = 3;				//speed shellCasing moves
		private var shellCasingDirection:Number = 0;	
		private var xMove:Number = 0;	
		private var yMove:Number = 0;	
		
		private var life:int = 150
		
		private var rotationSpeed = 0;
		
		private var globalX:Number;
		private var globalY:Number;
		protected var Position:Dot;
		
		public var camTarget:Boolean = false;
		
		private var damage:int = 0;
		private var force:int = 0;
		private var ricochet = false;
		protected var range:int = 40;
		private var index:uint = 0;
		private var xCollision;
		private var yCollision;

		private var soundChannel:SoundChannel = new SoundChannel();
		private var ricochetSound:Sound = new Thwack();
		
		public function ShellCasing(world,X,Y,Direction,Rotation):void 
		{
			this.WorldRef = world;
			
			rotationSpeed = (Math.random() - 0.5) * 20
			
			shellCasingSpeed = (Math.random() * shellCasingSpeed - 1) + 1
			
			x = X;
			y = Y;
			shellCasingDirection = Direction
			this.rotation = Direction;
			
			xMove = Math.cos(Direction *Math.PI/180 +1.58)
			yMove = Math.sin(Direction *Math.PI/180 +1.58)
			
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		
		}
		
		public function removeSelf():void									
		{
			removeEventListener(Event.ENTER_FRAME, loop);					
			
			WorldRef.removeChild(this);
		}
		
		public function loop(evt:Event = void):void				
		{
			if (scaleX > 0.6)
			{
				rotation += rotationSpeed
				x += xMove * shellCasingSpeed
				y += yMove * shellCasingSpeed
				scaleX -= 0.05;
				scaleY -= 0.05;
			}
			
			else if (shellCasingSpeed > 0)
			{
				x += xMove * shellCasingSpeed
				y += yMove * shellCasingSpeed
				shellCasingSpeed -= Math.random() * 5
			}
			
			else if (life > 0)
			{
				life --;
			}
			
			else if (alpha > 0)
			{
				alpha -= 0.1;
			}
			
			else
			{
				removeSelf();
			}
		}
	}
}