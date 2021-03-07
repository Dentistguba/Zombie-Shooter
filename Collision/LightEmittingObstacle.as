package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.Shape;
	
	public class LightEmittingObstacle extends Obstacle
	{		
		private var lightRef
		private var lightGraphic:Shape
		private var lightMaskGraphic:Shape
		private var lightMaskRef
		private var WorldRef
	
		public function LightEmittingObstacle():void 
		{	
			super()
			addEventListener(Event.ENTER_FRAME,init)
		}
		
		public function init(evt:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,init)
			lightMaskRef = lightMask
			Engine.world.darkness.darknessMask.staticDarknessMask.addChild(lightMask)
			lightMask.x = x;
			lightMask.y = y;
			
			lightRef = light
			
			rayCast()
			
			Engine.world.lightLayer.addChild(light)
			light.x = x
			light.y = y
		}
		
		public function rayCast()
		{				
			lightMaskGraphic = new Shape();
			lightMaskGraphic.graphics.lineStyle(0,0xFFFFFF,0);
			lightMaskGraphic.graphics.moveTo(0,0)
			lightMaskGraphic.graphics.beginFill(0xFFFF00,1);
			
			lightGraphic = new Shape();
			lightGraphic.graphics.lineStyle(0,0xFFFFFF,0);
			lightGraphic.graphics.moveTo(0,0)
			lightGraphic.graphics.beginFill(0xFFFF00,0.5);
			
			for (var i:int = 0; i < 370; i+= 10)
			{
				var rayPosition:Point = new Point(0,0)
				
				var	yMove = Math.sin(i *Math.PI/180 +1.58) * 10
				var xMove = Math.cos(i *Math.PI/180 +1.58) * 10
				
				for (var n = 0; n < 16; n++)
				{
					rayPosition.y += yMove
					rayPosition.x += xMove
					
					if (n == 15)
					{
						var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
						
						var pointLocal = light.globalToLocal(pointGlobal)
							
						lightMaskGraphic.graphics.lineTo(pointLocal.x * 0.8, pointLocal.y * 0.8);
						lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y);
					}
					
					for (var g:int = 0; g < Engine.obstacleList.length; g++)
					{		
						if (Engine.obstacleList[g] != this && Engine.obstacleList[g].alpha == 100)
						{
							var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))

							if (Engine.obstacleList[g].hitTestPoint(pointGlobal.x,pointGlobal.y,false))
							{
								n = 100
							
								var pointLocal = light.globalToLocal(pointGlobal)
							
								lightMaskGraphic.graphics.lineTo(pointLocal.x / 2, pointLocal.y / 2);
								lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y);
							}
						}
					}
				}
			}
			
			lightMaskGraphic.graphics.endFill();
			lightMaskRef.addChild(lightMaskGraphic);				
			
			lightGraphic.graphics.endFill();
			lightRef.addChild(lightGraphic);				
		}
	}
}