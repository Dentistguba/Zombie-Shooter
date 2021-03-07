package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	
	public class Vehicle extends MovieClip
	{
		protected const maxSpeed = 15;
		protected const maxReverseSpeed = 5;
		protected var speed = 0;
		protected var graphicDegs:Number;
		protected var pointList:Array = new Array();
		
		public var lightMaskRef
		protected var lightGraphic
		protected var lightGraphicRight
		
		public function Vehicle():void
		{
			Engine.vehicleList.push(this);
			pointList.push(point1,point2,point3,point4)
						
			addEventListener(Event.ENTER_FRAME,init)
		}
		
		private function init(evt:Event)
		{
			removeEventListener(Event.ENTER_FRAME,init)
			lightMaskRef = lightMask
			Engine.world.darkness.darknessMask.addChild(lightMask)
			lightMask.x = x;
			lightMask.y = y;
		}
		
		public function update():void
		{
			lightMaskRef.x = x;
			lightMaskRef.y = y;
			lightMaskRef.rotation = rotation;
			
			light.alpha = 1-Engine.world.darkness.darknessMask.daylight.alpha;
		}
		
		protected function shineLight():void
		{
			if(lightGraphic != null && light.contains(lightGraphic))
					light.removeChild(lightGraphic)
			
			lightGraphic = new Shape();
			lightGraphic.graphics.lineStyle(0,0xFFFFFF,0);
			lightGraphic.graphics.moveTo(-18,-60)
			lightGraphic.graphics.beginFill(0xFFFFFF,1/*1-Engine.world.darkness.darknessMask.daylight.alpha*/);
			
			for (var i:int = -1; i < 2; i++)
			{
				var rayPosition:Point = new Point(-18,0)
				
				var	yMove = -20 - (2 - Math.abs(i))
				var xMove = i*3
				
				for (var n = 0; n < 8; n++)
				{
					rayPosition.y += yMove
					rayPosition.x += xMove
					
					if (n == 7)
					{
						lightMask.light.scaleY = 1
						
						var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
						
						var pointLocal = light.globalToLocal(pointGlobal)
							

						lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y);
					}
					
					else
					{
						for (var g:int = 0; g < Engine.obstacleList.length; g++)
						{		
							if (Engine.obstacleList[g] != this && Engine.obstacleList[g].alpha == 100)
							{
								var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
	
								if (Engine.obstacleList[g].hitTestPoint(pointGlobal.x,pointGlobal.y,false))
								{
									if (i == 0)
									{
										if(n > 0)
											lightMask.light.scaleY = 0.05 + (0.95 * (n/6))
											
										else
											lightMask.light.scaleY = 0.05
									}
									
									n = 100
								
									var pointLocal = light.globalToLocal(pointGlobal)
								
	
									lightGraphic.graphics.lineTo(pointLocal.x, pointLocal.y);
								}
							}
						}
					}
				}
			}
			
			if(lightGraphicRight != null && light.contains(lightGraphicRight))
					light.removeChild(lightGraphicRight)
			
			lightGraphicRight = new Shape();
			lightGraphicRight.graphics.lineStyle(0,0xFFFFFF,0);
			lightGraphicRight.graphics.moveTo(18,-60)
			lightGraphicRight.graphics.beginFill(0xFFFFFF,1/*1-Engine.world.darkness.darknessMask.daylight.alpha*/);
			
			for (var i:int = -1; i < 2; i++)
			{
				var rayPosition:Point = new Point(18,0)
				
				var	yMove = -20 - (2 - Math.abs(i))
				var xMove = i*3
				
				for (var n = 0; n < 8; n++)
				{
					rayPosition.y += yMove
					rayPosition.x += xMove
					
					if (n == 7)
					{
						lightMask.light.scaleY = 1
						
						var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
						
						var pointLocal = light.globalToLocal(pointGlobal)
							

						lightGraphicRight.graphics.lineTo(pointLocal.x, pointLocal.y);
					}
					
					else
					{
						for (var g:int = 0; g < Engine.obstacleList.length; g++)
						{		
							if (Engine.obstacleList[g] != this && Engine.obstacleList[g].alpha == 100)
							{
								var pointGlobal = light.localToGlobal(new Point(rayPosition.x,rayPosition.y))
	
								if (Engine.obstacleList[g].hitTestPoint(pointGlobal.x,pointGlobal.y,false))
								{
									if (i == 0)
									{
										if(n > 0)
											lightMask.light.scaleY = 0.05 + (0.95 * (n/6))
											
										else
											lightMask.light.scaleY = 0.05
									}
									
									n = 100
								
									var pointLocal = light.globalToLocal(pointGlobal)
								
	
									lightGraphicRight.graphics.lineTo(pointLocal.x, pointLocal.y);
								}
							}
						}
					}
				}
			}
			
			lightGraphic.graphics.endFill();
			lightGraphicRight.graphics.endFill();
			light.addChild(lightGraphic);
			light.addChild(lightGraphicRight);
		}
		
		public function rotateLeft():void
		{
			if (speed/2 <= 2 && speed/2 >= -2)
				rotation -= speed/10;
				
			else 
				rotation -= speed/10;
		}
		
		public function rotateRight():void
		{
			if (speed/2 <= 2 && speed < 0)
				rotation += speed/10;
			
			else 
				rotation += speed/10;
		}
		
		public function moveForward():void
		{
			if (speed < maxSpeed)
				speed += 0.5;
			
			/*graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * speed);												
			this.x += (Math.sin(graphicDegs * (Math.PI/180)) * speed);*/
		}
		
		public function moveBackward():void
		{
			if (speed > -maxReverseSpeed)
				speed -= 0.5;
			
			/*graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			this.y += (Math.cos(graphicDegs * (Math.PI/180)) * speed);												
			this.x -= (Math.sin(graphicDegs * (Math.PI/180)) * speed);*/
		}
		
		public function Loop(leftButton,rightButton):void
		{
			graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			if (speed >= 0.2)
				speed -= 0.2;
				
			else if (speed <= -0.2)
				speed += 0.2;
				
			else
				speed = 0;
				
				
			if (leftButton == true)
				rotateLeft();
				
			if (rightButton == true)
				rotateRight();
				
			this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * speed/3);												
			this.x += (Math.sin(graphicDegs * (Math.PI/180)) * speed/3);
			collide();
			
			if (leftButton == true)
				rotateLeft();
				
			if (rightButton == true)
				rotateRight();
			
			this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * speed/3);												
			this.x += (Math.sin(graphicDegs * (Math.PI/180)) * speed/3);
			collide();
			
			if (leftButton == true)
				rotateLeft();
				
			if (rightButton == true)
				rotateRight();
			
			this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * speed/3);												
			this.x += (Math.sin(graphicDegs * (Math.PI/180)) * speed/3);
			collide();
			
			shineLight();
			update()
		}
		
		private function obstCollideA(obstacle):void
		{
			
		}
		
		private function obstCollideB(obstacle):void
		{
			for (var i:int = 0; i < obstacle.pointList.length; i++)
			{
				var xCollision = 0;
				var yCollision = 0;
				//var pointGlobal = Engine.world.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y))
						
				/*if (hit.hitTestPoint(pointGlobal.x,pointGlobal.y,true))
				{*/
					var pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y)));
						
					//trace (obstacle.pointList[i].x,obstacle.pointList[i].y)
						
					if (pointGlobal.x > hit.x)
					{
						xCollision = ((hit.width /2)-(pointGlobal.x) );	
					}
						
					else if (pointGlobal.x < hit.x)
					{
						xCollision = ((pointGlobal.x)+(hit.width /2) );	
					}
					
					if (pointGlobal.y > hit.y)
					{
						yCollision = ((hit.height /2)-(pointGlobal.y) );	
					}
					
					else if (pointGlobal.y < hit.y)
					{
						yCollision = ((pointGlobal.y)+(hit.height /2) );	
					}
					
					if (xCollision > 0 && xCollision < yCollision && yCollision > 0)
					{
						//trace ('x col',xCollision,yCollision)
						speed = 0;
						
						if (yCollision < 1)
							yCollision = 1;
						
						if (pointGlobal.x > 0)
						{
							col.x = -xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(-xCollision,0)));
						}
								
						else if (pointGlobal.x < 0)
						{
							col.x = xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(xCollision,0)));
						}
						
						x = pointGlobal.x;
						y = pointGlobal.y;
					}
						
					else if (yCollision <= xCollision && yCollision > 0 && xCollision > 0)
					{
						//trace ('y col',xCollision,yCollision)
						speed = 0;
						
						if (yCollision < 1)
							yCollision = 1;
						
						if (pointGlobal.y > 0)
						{
							col.y = -yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,-yCollision)));
						}
								
						else if (pointGlobal.y < 0)
						{
							col.y = yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,yCollision)));
						}
						
						x = pointGlobal.x;
						y = pointGlobal.y;
					}
					
					
				/*}*/
			}
		}
		
		private function lowObstCollideA(obstacle):void
		{
			var xCollision = 0;
			var yCollision = 0;
			var pointGlobal;			
	
			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(point1.x,point1.y)))
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				if ( rotation < 0 && rotation > -45)
					rotation += speed / 10;
								
				else if (rotation < -45 && rotation > -90)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < -90 && rotation > -128)
					rotation += speed / 10;
								
				else if (rotation < -128 && rotation > -180)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < 180 && rotation > 128)
					rotation += speed / 10;
								
				else if (rotation < 128 && rotation > 90)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < 90 && rotation > 45)
					rotation += speed / 10;
								
				else if (rotation < 45 && rotation > 0)
					speed = 0;//rotation -= speed / 10;
							
				if (speed >= 2)
					speed -= 2;
				
				else if (speed <= -2)
					speed += 2;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
						x += xCollision ;
								
					else if (pointGlobal.x < obstacle.x)
						x -= xCollision ;
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
						y += yCollision ;
						
					else if (pointGlobal.y < obstacle.y)
						y -= yCollision ;
				}
			}

			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point2.x,/*pointList[i]*/point2.y)))

			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
							
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				if ( rotation < 0 && rotation > -45)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < -45 && rotation > -90)
					rotation -= speed / 10;
								
				else if (rotation < -90 && rotation > -128)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < -128 && rotation > -180)
					rotation -= speed / 10;
								
				else if (rotation < 180 && rotation > 128)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < 128 && rotation > 90)
					rotation -= speed / 10;
								
				else if (rotation < 90 && rotation > 45)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < 45 && rotation > 0)
					rotation -= speed / 10;
							
				if (speed >= 2)
					speed -= 2;
				
				else if (speed <= -2)
					speed += 2;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
						x += xCollision ;
								
					else if (pointGlobal.x < obstacle.x)
						x -= xCollision ;
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
						y += yCollision ;
								
					else if (pointGlobal.y < obstacle.y)
						y -= yCollision ;
				}
			}
			

			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point3.x,/*pointList[i]*/point3.y)));
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
					
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				if ( rotation < 0 && rotation > -45)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < -45 && rotation > -90)
					rotation += speed / 10;
							
				else if (rotation < -90 && rotation > -128)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < -128 && rotation > -180)
					rotation += speed / 10;
								
				else if (rotation < 180 && rotation > 128)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < 128 && rotation > 90)
					rotation += speed / 10;
								
				else if (rotation < 90 && rotation > 45)
					speed = 0;//rotation -= speed / 10;
								
				else if (rotation < 45 && rotation > 0)
					rotation += speed / 10;
								
				if (speed >= 2)
					speed -= 2;
				
				else if (speed <= -2)
					speed += 2;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
						x += xCollision ;
								
					else if (pointGlobal.x < obstacle.x)
						x -= xCollision ;
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
						y += yCollision ;
								
					else if (pointGlobal.y < obstacle.y)
						y -= yCollision ;
				}
			}


			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point4.x,/*pointList[i]*/point4.y)))
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
				
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				if ( rotation < 0 && rotation > -45)
					rotation -= speed / 10;
								
				else if (rotation < -45 && rotation > -90)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < -90 && rotation > -128)
					rotation -= speed / 10;
								
				else if (rotation < -128 && rotation > -180)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < 180 && rotation > 128)
					rotation -= speed / 10;
								
				else if (rotation < 128 && rotation > 90)
					speed = 0;//rotation += speed / 10;
								
				else if (rotation < 90 && rotation > 45)
					rotation -= speed / 10;
								
				else if (rotation < 45 && rotation > 0)
					speed = 0;//rotation += speed / 10;
								
				if (speed >= 2)
					speed -= 2;
				
				else if (speed <= -2)
					speed += 2;	
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
						x += xCollision ;
								
					else if (pointGlobal.x < obstacle.x)
						x -= xCollision ;
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
						y += yCollision ;
								
					else if (pointGlobal.y < obstacle.y)
						y -= yCollision ;
				}
			}			
		}
		
		private function lowObstCollideB(obstacle):void
		{
			for (var i:int = 0; i < obstacle.pointList.length; i++)
			{
				var xCollision = 0;
				var yCollision = 0;
				//var pointGlobal = Engine.world.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y))
						
				/*if (hit.hitTestPoint(pointGlobal.x,pointGlobal.y,true))
				{*/
					var pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y)));
						
					//trace (obstacle.pointList[i].x,obstacle.pointList[i].y)
						
					if (pointGlobal.x > hit.x)
					{
						xCollision = ((hit.width /2)-(pointGlobal.x) );	
					}
						
					else if (pointGlobal.x < hit.x)
					{
						xCollision = ((pointGlobal.x)+(hit.width /2) );	
					}
					
					if (pointGlobal.y > hit.y)
					{
						yCollision = ((hit.height /2)-(pointGlobal.y) );	
					}
					
					else if (pointGlobal.y < hit.y)
					{
						yCollision = ((pointGlobal.y)+(hit.height /2) );	
					}
					
					if (xCollision > 0 && xCollision < yCollision && yCollision > 0)
					{
						//trace ('x col',xCollision,yCollision)
						speed = 0;
						
						if (yCollision < 1)
							yCollision = 1;
						
						if (pointGlobal.x > 0)
						{
							col.x = -xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(-xCollision,0)));
						}
								
						else if (pointGlobal.x < 0)
						{
							col.x = xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(xCollision,0)));
						}
						
						x = pointGlobal.x;
						y = pointGlobal.y;
					}
						
					else if (yCollision <= xCollision && yCollision > 0 && xCollision > 0)
					{
						//trace ('y col',xCollision,yCollision)
						speed = 0;
						
						if (yCollision < 1)
							yCollision = 1;
						
						if (pointGlobal.y > 0)
						{
							col.y = -yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,-yCollision)));
						}
								
						else if (pointGlobal.y < 0)
						{
							col.y = yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,yCollision)));
						}
						
						x = pointGlobal.x;
						y = pointGlobal.y;
					}
				
			}
		}
		
		private function moveableObstCollideA(obstacle):void
		{
			var xCollision = 0;
			var yCollision = 0;
			var pointGlobal;			
	
			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(point1.x,point1.y)))
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				//if ( rotation < 0 && rotation > -45)
//					rotation += speed / 20;
//								
//				else if (rotation < -45 && rotation > -90)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < -90 && rotation > -128)
//					rotation += speed / 20;
//								
//				else if (rotation < -128 && rotation > -180)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < 180 && rotation > 128)
//					rotation += speed / 20;
//								
//				else if (rotation < 128 && rotation > 90)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < 90 && rotation > 45)
//					rotation += speed / 20;
//								
//				else if (rotation < 45 && rotation > 0)
//					speed = 0;//rotation -= speed / 10;
							
				if (speed >= 0.3)
					speed -= 0.15;
					
				else if (speed >= 0.5)
					speed -= 0.05;
				
				else if (speed <= -0.3)
					speed += 0.15;
					
				else if (speed <= -0.1)
					speed +- 0.05;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
					{
						x += xCollision / 2;
						obstacle.x -= xCollision / 2;
					}
								
					else if (pointGlobal.x < obstacle.x)
					{
						x -= xCollision / 2;
						obstacle.x += xCollision / 2;
					}
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
					{
						y += yCollision / 2;
						obstacle.y -= yCollision / 2;
					}
								
					else if (pointGlobal.y < obstacle.y)
					{
						y -= yCollision / 2;
						obstacle.y += yCollision / 2;
					}
				}
			}

			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point2.x,/*pointList[i]*/point2.y)))

			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
							
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				//if ( rotation < 0 && rotation > -45)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < -45 && rotation > -90)
//					rotation -= speed / 20;
//								
//				else if (rotation < -90 && rotation > -128)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < -128 && rotation > -180)
//					rotation -= speed / 20;
//								
//				else if (rotation < 180 && rotation > 128)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < 128 && rotation > 90)
//					rotation -= speed / 20;
//								
//				else if (rotation < 90 && rotation > 45)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < 45 && rotation > 0)
//					rotation -= speed / 20;
							
				if (speed >= 0.3)
					speed -= 0.15;
					
				else if (speed >= 0.5)
					speed -= 0.05;
				
				else if (speed <= -0.3)
					speed += 0.15;
					
				else if (speed <= -0.1)
					speed +- 0.05;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
					{
						x += xCollision / 2;
						obstacle.x -= xCollision / 2;
					}
								
					else if (pointGlobal.x < obstacle.x)
					{
						x -= xCollision / 2;
						obstacle.x += xCollision / 2;
					}
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
					{
						y += yCollision / 2;
						obstacle.y -= yCollision / 2;
					}
								
					else if (pointGlobal.y < obstacle.y)
					{
						y -= yCollision / 2;
						obstacle.y += yCollision / 2;
					}
				}
			}
			

			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point3.x,/*pointList[i]*/point3.y)));
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
					
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				//if ( rotation < 0 && rotation > -45)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < -45 && rotation > -90)
//					rotation += speed / 20;
//							
//				else if (rotation < -90 && rotation > -128)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < -128 && rotation > -180)
//					rotation += speed / 20;
//								
//				else if (rotation < 180 && rotation > 128)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < 128 && rotation > 90)
//					rotation += speed / 20;
//								
//				else if (rotation < 90 && rotation > 45)
//					speed = 0;//rotation -= speed / 10;
//								
//				else if (rotation < 45 && rotation > 0)
//					rotation += speed / 20;
								
				if (speed >= 0.3)
					speed -= 0.15;
					
				else if (speed >= 0.5)
					speed -= 0.05;
				
				else if (speed <= -0.3)
					speed += 0.15;
					
				else if (speed <= -0.1)
					speed +- 0.05;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
					{
						x += xCollision / 2;
						obstacle.x -= xCollision / 2;
					}
								
					else if (pointGlobal.x < obstacle.x)
					{
						x -= xCollision / 2;
						obstacle.x += xCollision / 2;
					}
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
					{
						y += yCollision / 2;
						obstacle.y -= yCollision / 2;
					}
								
					else if (pointGlobal.y < obstacle.y)
					{
						y -= yCollision / 2;
						obstacle.y += yCollision / 2;
					}
				}
			}


			pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point4.x,/*pointList[i]*/point4.y)))
							
			if (pointGlobal.x > obstacle.x)
			{
				xCollision = ( (obstacle.x + obstacle.width /2)-(pointGlobal.x) );	
				
			}
						
			else if (pointGlobal.x < obstacle.x)
			{
				xCollision = ( (pointGlobal.x)-(obstacle.x - obstacle.width /2));		
													
			}
						
			if (pointGlobal.y > obstacle.y)
			{
				yCollision = ( (obstacle.y + obstacle.height /2)-(pointGlobal.y));		
							
			}		
						
			else if (pointGlobal.y < obstacle.y)
			{
				yCollision = ( (pointGlobal.y)-(obstacle.y - obstacle.height /2));							
			}
							
			if (xCollision > 0 && yCollision > 0)
			{
				//if ( rotation < 0 && rotation > -45)
//					rotation -= speed / 20;
//								
//				else if (rotation < -45 && rotation > -90)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < -90 && rotation > -128)
//					rotation -= speed / 20;
//								
//				else if (rotation < -128 && rotation > -180)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < 180 && rotation > 128)
//					rotation -= speed / 20;
//								
//				else if (rotation < 128 && rotation > 90)
//					speed = 0;//rotation += speed / 10;
//								
//				else if (rotation < 90 && rotation > 45)
//					rotation -= speed / 20;
//								
//				else if (rotation < 45 && rotation > 0)
//					speed = 0;//rotation += speed / 10;
							
				if (speed >= 0.3)
					speed -= 0.15;
					
				else if (speed >= 0.5)
					speed -= 0.05;
				
				else if (speed <= -0.3)
					speed += 0.15;
					
				else if (speed <= -0.1)
					speed +- 0.05;
							
				if (xCollision < yCollision)
				{
					if (pointGlobal.x > obstacle.x)
					{
						x += xCollision / 2;
						obstacle.x -= xCollision / 2;
					}
								
					else if (pointGlobal.x < obstacle.x)
					{
						x -= xCollision / 2;
						obstacle.x += xCollision / 2;
					}
				}
						
				else if (yCollision < xCollision)
				{
					if (pointGlobal.y > obstacle.y)
					{
						y += yCollision / 2;
						obstacle.y -= yCollision / 2;
					}
								
					else if (pointGlobal.y < obstacle.y)
					{
						y -= yCollision / 2;
						obstacle.y += yCollision / 2;
					}
				}
			}			
		}
		
		private function moveableObstCollideB(obstacle):void
		{
			for (var i:int = 0; i < obstacle.pointList.length; i++)
			{
				var xCollision = 0;
				var yCollision = 0;
				//var pointGlobal = Engine.world.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y))
						
				/*if (hit.hitTestPoint(pointGlobal.x,pointGlobal.y,true))
				{*/
					var pointGlobal = hit.globalToLocal(obstacle.localToGlobal(new Point(obstacle.pointList[i].x,obstacle.pointList[i].y)));
						
					//trace (obstacle.pointList[i].x,obstacle.pointList[i].y)
						
					if (pointGlobal.x > hit.x)
					{
						xCollision = ((hit.width /2)-(pointGlobal.x) );	
					}
						
					else if (pointGlobal.x < hit.x)
					{
						xCollision = ((pointGlobal.x)+(hit.width /2) );	
					}
					
					if (pointGlobal.y > hit.y)
					{
						yCollision = ((hit.height /2)-(pointGlobal.y) );	
					}
					
					else if (pointGlobal.y < hit.y)
					{
						yCollision = ((pointGlobal.y)+(hit.height /2) );	
					}
					
					if (xCollision > 0 && xCollision < yCollision && yCollision > 0)
					{
//						trace ('x col',xCollision,yCollision)
						if (speed >= 0.3)
							speed -= 0.15;
					
						else if (speed >= 0.5)
							speed -= 0.05;
				
						else if (speed <= -0.3)
							speed += 0.15;
					
						else if (speed <= -0.1)
							speed +- 0.05;
						
						if (xCollision < 1)
							xCollision = 1;
						
						if (pointGlobal.x > 0)
						{
							col.x = -xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(-xCollision/2,0)));
							
							x = pointGlobal.x;
							y = pointGlobal.y;
							
							pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.x,obstacle.y) ))
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(pointGlobal.x + (xCollision/2),pointGlobal.y)));
							
							obstacle.x = pointGlobal.x;
							obstacle.y = pointGlobal.y;
						}
								
						else if (pointGlobal.x < 0)
						{
							col.x = xCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(xCollision/2,0)));
							
							x = pointGlobal.x;
							y = pointGlobal.y;
							
							
							pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.x,obstacle.y) ))
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(pointGlobal.x - (xCollision/2),pointGlobal.y)));
							
							obstacle.x = pointGlobal.x;
							obstacle.y = pointGlobal.y;
						}
					}
						
					else if (yCollision <= xCollision && yCollision > 0 && xCollision > 0)
					{
						//trace ('y col',xCollision,yCollision)
						if (speed >= 0.3)
							speed -= 0.15;
					
						else if (speed >= 0.5)
							speed -= 0.05;
				
						else if (speed <= -0.3)
							speed += 0.15;
					
						else if (speed <= -0.1)
							speed +- 0.05;
						
						if (yCollision < 1)
							yCollision = 1;
						
						if (pointGlobal.y > 0)
						{
							col.y = -yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,-yCollision/2)));
							
							x = pointGlobal.x;
							y = pointGlobal.y;
							
							pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.x,obstacle.y) ))
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(pointGlobal.x,pointGlobal.y + (yCollision/2) )));
							
							obstacle.x = pointGlobal.x;
							obstacle.y = pointGlobal.y;
						}
								
						else if (pointGlobal.y < 0)
						{
							col.y = yCollision;
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(0,yCollision/2)));
							
							x = pointGlobal.x;
							y = pointGlobal.y;
							
							pointGlobal = hit.globalToLocal(Engine.world.localToGlobal(new Point(obstacle.x,obstacle.y) ))
							pointGlobal = Engine.world.globalToLocal(hit.localToGlobal(new Point(pointGlobal.x,pointGlobal.y - (yCollision/2) )));
							
							obstacle.x = pointGlobal.x;
							obstacle.y = pointGlobal.y;
						}
						
						
					}
				
			}
		}
		
		public function collide():void
		{
			// collision
			var xCollision = 0;
			var yCollision = 0;
			
			
			for (var i:int = 0; i < Engine.obstacleList.length; i++)
			{
				if (Engine.obstacleList[i].alpha == 100 && hit.hitTestObject(Engine.obstacleList[i]))
				{
					/*for (var i:int = 0; i < pointList.length; i++)
					{*/
						var pointGlobal;			
	
						pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(point1.x,point1.y)))
							
						if (pointGlobal.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(pointGlobal.x) );	
							
						}
						
						else if (pointGlobal.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (pointGlobal.x)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
													
						}
						
						if (pointGlobal.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(pointGlobal.y));		
							
						}		
						
						else if (pointGlobal.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (pointGlobal.y)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));							
						}
							
						if (xCollision > 0 && yCollision > 0)
						{
							if ( rotation < 0 && rotation > -45)
								rotation += speed / 10;
								
							else if (rotation < -45 && rotation > -90)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < -90 && rotation > -128)
								rotation += speed / 10;
								
							else if (rotation < -128 && rotation > -180)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < 180 && rotation > 128)
								rotation += speed / 10;
								
							else if (rotation < 128 && rotation > 90)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < 90 && rotation > 45)
								rotation += speed / 10;
								
							else if (rotation < 45 && rotation > 0)
								speed = 0;//rotation -= speed / 10;
							
							if (speed >= 2)
								speed -= 2;
				
							else if (speed <= -2)
								speed += 2;
							
							if (xCollision < yCollision)
							{
								if (pointGlobal.x > Engine.obstacleList[i].x)
									x += xCollision ;
								
								else if (pointGlobal.x < Engine.obstacleList[i].x)
									x -= xCollision ;
							}
						
							else if (yCollision < xCollision)
							{
								if (pointGlobal.y > Engine.obstacleList[i].y)
									y += yCollision ;
								
								else if (pointGlobal.y < Engine.obstacleList[i].y)
									y -= yCollision ;
							}
						}

						pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point2.x,/*pointList[i]*/point2.y)))

						if (pointGlobal.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(pointGlobal.x) );	
							
						}
						
						else if (pointGlobal.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (pointGlobal.x)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
													
						}
						
						if (pointGlobal.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(pointGlobal.y));		
							
						}		
						
						else if (pointGlobal.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (pointGlobal.y)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));							
						}
							
						if (xCollision > 0 && yCollision > 0)
						{
							if ( rotation < 0 && rotation > -45)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < -45 && rotation > -90)
								rotation -= speed / 10;
								
							else if (rotation < -90 && rotation > -128)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < -128 && rotation > -180)
								rotation -= speed / 10;
								
							else if (rotation < 180 && rotation > 128)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < 128 && rotation > 90)
								rotation -= speed / 10;
								
							else if (rotation < 90 && rotation > 45)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < 45 && rotation > 0)
								rotation -= speed / 10;
							
							if (speed >= 2)
								speed -= 2;
				
							else if (speed <= -2)
								speed += 2;
							
							if (xCollision < yCollision)
							{
								if (pointGlobal.x > Engine.obstacleList[i].x)
									x += xCollision ;
								
								else if (pointGlobal.x < Engine.obstacleList[i].x)
									x -= xCollision ;
							}
						
							else if (yCollision < xCollision)
							{
								if (pointGlobal.y > Engine.obstacleList[i].y)
									y += yCollision ;
								
								else if (pointGlobal.y < Engine.obstacleList[i].y)
									y -= yCollision ;
							}
						}

						pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point3.x,/*pointList[i]*/point3.y)))

							
//							
						if (pointGlobal.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(pointGlobal.x) );	
							
						}
						
						else if (pointGlobal.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (pointGlobal.x)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
													
						}
						
						if (pointGlobal.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(pointGlobal.y));		
							
						}		
						
						else if (pointGlobal.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (pointGlobal.y)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));							
						}
							
						if (xCollision > 0 && yCollision > 0)
						{
							if ( rotation < 0 && rotation > -45)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < -45 && rotation > -90)
								rotation += speed / 10;
								
							else if (rotation < -90 && rotation > -128)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < -128 && rotation > -180)
								rotation += speed / 10;
								
							else if (rotation < 180 && rotation > 128)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < 128 && rotation > 90)
								rotation += speed / 10;
								
							else if (rotation < 90 && rotation > 45)
								speed = 0;//rotation -= speed / 10;
								
							else if (rotation < 45 && rotation > 0)
								rotation += speed / 10;
								
							if (speed >= 2)
								speed -= 2;
				
							else if (speed <= -2)
								speed += 2;
							
							if (xCollision < yCollision)
							{
								if (pointGlobal.x > Engine.obstacleList[i].x)
									x += xCollision ;
								
								else if (pointGlobal.x < Engine.obstacleList[i].x)
									x -= xCollision ;
							}
						
							else if (yCollision < xCollision)
							{
								if (pointGlobal.y > Engine.obstacleList[i].y)
									y += yCollision ;
								
								else if (pointGlobal.y < Engine.obstacleList[i].y)
									y -= yCollision ;
							}
						}


						pointGlobal = Engine.world.globalToLocal(localToGlobal(new Point(/*pointList[i]*/point4.x,/*pointList[i]*/point4.y)))
							
						if (pointGlobal.x > Engine.obstacleList[i].x)
						{
							xCollision = ( (Engine.obstacleList[i].x + Engine.obstacleList[i].width /2)-(pointGlobal.x) );	
							
						}
						
						else if (pointGlobal.x < Engine.obstacleList[i].x)
						{
							xCollision = ( (pointGlobal.x)-(Engine.obstacleList[i].x - Engine.obstacleList[i].width /2));		
													
						}
						
						if (pointGlobal.y > Engine.obstacleList[i].y)
						{
							yCollision = ( (Engine.obstacleList[i].y + Engine.obstacleList[i].height /2)-(pointGlobal.y));		
							
						}		
						
						else if (pointGlobal.y < Engine.obstacleList[i].y)
						{
							yCollision = ( (pointGlobal.y)-(Engine.obstacleList[i].y - Engine.obstacleList[i].height /2));							
						}
							
						if (xCollision > 0 && yCollision > 0)
						{
							if ( rotation < 0 && rotation > -45)
								rotation -= speed / 10;
								
							else if (rotation < -45 && rotation > -90)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < -90 && rotation > -128)
								rotation -= speed / 10;
								
							else if (rotation < -128 && rotation > -180)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < 180 && rotation > 128)
								rotation -= speed / 10;
								
							else if (rotation < 128 && rotation > 90)
								speed = 0;//rotation += speed / 10;
								
							else if (rotation < 90 && rotation > 45)
								rotation -= speed / 10;
								
							else if (rotation < 45 && rotation > 0)
								speed = 0;//rotation += speed / 10;
								
							if (speed >= 2)
								speed -= 2;
				
							else if (speed <= -2)
								speed += 2;	
							
							if (xCollision < yCollision)
							{
								if (pointGlobal.x > Engine.obstacleList[i].x)
									x += xCollision ;
								
								else if (pointGlobal.x < Engine.obstacleList[i].x)
									x -= xCollision ;
							}
						
							else if (yCollision < xCollision)
							{
								if (pointGlobal.y > Engine.obstacleList[i].y)
									y += yCollision ;
								
								else if (pointGlobal.y < Engine.obstacleList[i].y)
									y -= yCollision ;
							}
						}
						obstCollideB(Engine.obstacleList[i]);
				}						
			}
			
			
			for (var i:int = 0; i < Engine.lowObstacleList.length; i++)
			{
				if (Engine.lowObstacleList[i].alpha == 100 && hit.hitTestObject(Engine.lowObstacleList[i]))
				{
					lowObstCollideA(Engine.lowObstacleList[i]);
					lowObstCollideB(Engine.lowObstacleList[i]);
				}
			}
			
			for (var i:int = 0; i < Engine.moveableObstacleList.length; i++)
			{
				if (Engine.moveableObstacleList[i].alpha == 100 && hit.hitTestObject(Engine.moveableObstacleList[i]))
				{
					moveableObstCollideA(Engine.moveableObstacleList[i]);
					moveableObstCollideB(Engine.moveableObstacleList[i]);
					Engine.moveableObstacleList[i].collide();
				}
			}
			
			for (var i:int = 0; i < Engine.lowMoveableObstacleList.length; i++)
			{
				if (Engine.lowMoveableObstacleList[i].alpha == 100 && hit.hitTestObject(Engine.lowMoveableObstacleList[i]))
				{
					moveableObstCollideA(Engine.lowMoveableObstacleList[i]);
					moveableObstCollideB(Engine.lowMoveableObstacleList[i]);
					Engine.lowMoveableObstacleList[i].collide();
				}
			}
		}
	}
}