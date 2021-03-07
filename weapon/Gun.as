package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	
	public class Gun extends MovieClip
	{
		public var WorldRef:World;
		public var Holder;
		public var Position:Point;
		public var End:Dot;
		public var mouseButton:Boolean;
		//protected const fireDelay:int = 2000;
		
		protected var reloadDelayTimer:Timer;
		protected var fireDelayTimer:Timer;
		protected var canFire:Boolean = true;
		
		private var bulletType = Bullet;	
		private var accuracy:int = 1;
		private var bulletNo:int = 1;
		public var ammo:int = 10;
		private var clipSize = 10;
		private var reloading:Boolean = false;
		
		public var fireSound:Sound;
		public var noFireSound:Sound = new CLICK01();
		public var reloadSound:Sound = new CLICK04();
		public var soundChannel:SoundChannel = new SoundChannel();
		
		/*
		private const bulletSpeed:int;
		private const bulletSpread:int;
		public const fireDelay:int;
		*/
		
		public function Gun(world,holder,x,y,fireDelay,bulletType,accuracy,sound,clipSize,reloadDelay,bulletNo = 1):void 
		{
			stop();
			
			End = new Dot;
			this.x = x;
			this.y = y;
			this.bulletType = bulletType;
			this.WorldRef = world;
			this.Holder = holder;
			this.accuracy = accuracy;
			this.bulletNo = bulletNo;
			Holder.weaponList.push(this);
			
			fireDelayTimer = new Timer (fireDelay,1);
			fireDelayTimer.addEventListener("timer", this.fireController);
			
			reloadDelayTimer = new Timer (reloadDelay,1);
			reloadDelayTimer.addEventListener("timer", this.Reload);
			
			fireSound = new sound();
			this.ammo = clipSize;
			this.clipSize = clipSize;
			
			
		}
		
		protected function fireController(evt:Event):void
		{
			canFire = true;
		}
		
		public function startFire():void
		{
			if (ammo <= 0 && clipSize > 0 || Holder.ammoList[bulletType] <= 0)
				noFireSound.play();
			
			mouseButton = true;
		}
		
		public function endFire():void
		{
			mouseButton = false;
			Holder.muzzleFlashMask.visible = false;
			gotoAndStop(1)
		}
		
		// fills gun either with clip size or player current ammo of correct type
		private function Reload(evt:Event):void
		{
			reloadSound.play();
			reloading = false;
			canFire = true;
			
			if (clipSize < Holder.ammoList[bulletType])
			{
				ammo = clipSize;
			}
			
			else
				ammo = Holder.ammoList[bulletType];
		}
		
		public function forceReload():void
		{
			reloadDelayTimer.start();
			reloading = true;
			canFire = false;
			gotoAndStop(1)
		}
		
		public function fire():void
		{
			if (canFire == true && Holder.ammoList[bulletType] > 0 && ammo > 0 || canFire == true && Holder.ammoList[bulletType] > 0 && clipSize == 0)
			{
				WorldRef.mouseFollow = false;
				
				// needed as gun is nested in holder
				Position = WorldRef.globalToLocal(localToGlobal(new Point(End.x,End.y)));
				
				// creates bullets (bulletNo used for shotgun)
				for (var i:int = 0; i < bulletNo; i++)
					WorldRef.addChildAt (new bulletType(WorldRef,Position.x, Position.y, Holder.Graphic.rotation + ((Math.random() -0.5) * accuracy) ),WorldRef.getChildIndex(Holder)-1);		//creates bullet 1
				
				// smoke effect
				WorldRef.addChildAt (new Smoke(WorldRef,Position.x, Position.y),WorldRef.getChildIndex(Holder)-1);

				
				Position = WorldRef.globalToLocal(localToGlobal(new Point(End.x,End.y + (height - 2))));
				
				WorldRef.addChildAt(new ShellCasing(WorldRef,Position.x, Position.y,(Holder.Graphic.rotation - 90) + (Math.random() * 10), (Math.random() -0.5) * 10),WorldRef.getChildIndex(Holder)-1);
				
				gotoAndPlay(2);
				Holder.muzzleFlashMask.visible = true;
				Holder.muzzleFlashMask.x = Holder.x
				Holder.muzzleFlashMask.y = Holder.y
				Holder.muzzleFlashMask.rotation = Holder.Graphic.rotation;

				
				//soundChannel.stop();
				soundChannel = fireSound.play();
				canFire = false;
				fireDelayTimer.start();
				
				// not used for flamethrower + minigun
				if (clipSize > 0)
					ammo --;
				
				// reduces players ammo of bulletType
				Holder.ammoList[bulletType] --;
				
				// reload start
				if (ammo == 0 && clipSize > 0)
				{
					reloadDelayTimer.start();
					reloading = true;
				}
					
			}
			
			else if (reloading != true && ammo <= 0 && clipSize > 0)
			{
				noFireSound.play();
				reloadDelayTimer.start();
				reloading = true;
			}
			
			else
			{
				Holder.muzzleFlashMask.visible = false;
				gotoAndStop(1)
			}
		}
	}
}