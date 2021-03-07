package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.geom.Point;

	
	public class Tank extends MovieClip
	{
		protected const maxSpeed = 4;
		protected const maxReverseSpeed = 4;
		protected var speed = 0;
		protected var graphicDegs:Number;
		protected var pointList:Array = new Array();
		
		protected var canFire:Boolean = true;
		protected var canFireCountdown:int = 50;
		
		protected var canFireMG:Boolean = true;
		protected var canFireMGCountdown:int = 50;
		
		protected var currentWeapon:int = 0;
		
		public function Tank()
		{
			Engine.vehicleList.push(this);
			pointList.push(point1,point2,point3,point4)
		}
		
		public function aimTurret():void
		{
			var MousePos:Point = (new Point(mouseX, mouseY));
				
	        var mouseAngle = Math.atan2(MousePos.x - turret.x,MousePos.y - turret.y)*180/Math.PI; 
				
			if (mouseAngle < 0)
				mouseAngle += 360;
				
			var turretDegs = turret.rotation
				
			if (turretDegs < 0)
				turretDegs += 360;
				
			var mouseRelativeAngle
			
			mouseRelativeAngle = mouseAngle + turretDegs;
			if (mouseRelativeAngle > 360)
				mouseRelativeAngle -= 360;
				
			if (mouseRelativeAngle >= 182 && mouseRelativeAngle <= 358)
				turret.rotation  -= 2;
				
			else if (mouseRelativeAngle <= 178 && mouseRelativeAngle >= 2)
				turret.rotation += 2;
				
			else 
			{
				mouseAngle = Math.atan2(MousePos.y - turret.y,MousePos.x - turret.x)*180/Math.PI + 90; 
				
				turret.rotation = mouseAngle
			}
			
			if (turret.mouseY < -100 && turret.mouseX - turret.machineGun.x < 20 && turret.mouseX - turret.machineGun.x > -20)
				turret.machineGun.rotation = Math.atan2(turret.mouseY - turret.machineGun.y,turret.mouseX - turret.machineGun.x)*180/Math.PI + 90
		}
		
		private function fire():void
		{
			if (currentWeapon == 0 && canFire == true)
			{
				var gunEnd = Engine.world.globalToLocal(turret.localToGlobal(new Point(0,-97)));
				
				Engine.world.addChildAt(new TankShell(Engine.world,gunEnd.x,gunEnd.y,turret.rotation + rotation),Engine.world.getChildIndex(this) + 1);
			
				canFire = false
				canFireCountdown = 50
			}
			
			else if (currentWeapon == 1 && canFireMG == true)
			{
				var gunEnd = Engine.world.globalToLocal(turret.machineGun.localToGlobal(new Point(0,-25)));
				
				Engine.world.addChildAt(new Bullet50Cal(Engine.world,gunEnd.x,gunEnd.y,turret.machineGun.rotation + turret.rotation + rotation),Engine.world.getChildIndex(this) + 1);
			
				canFireMG = false
				canFireMGCountdown = 10
			}
		}
		
		public function rotateLeft():void
		{
			if (speed > 1 || speed < -1)
				rotation -= Math.abs(1/speed);
				
			else
				rotation -= 1
		}
		
		public function rotateRight():void
		{
			if (speed > 1 || speed < -1)
				rotation += Math.abs(1/speed);
			
			else
				rotation += 1
		}
		
		public function moveForward():void
		{
			if (speed < maxSpeed)
				speed += 0.1;
			
			/*graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			this.y -= (Math.cos(graphicDegs * (Math.PI/180)) * speed);												
			this.x += (Math.sin(graphicDegs * (Math.PI/180)) * speed);*/
		}
		
		public function moveBackward():void
		{
			if (speed > -maxReverseSpeed)
				speed -= 0.1;
			
			/*graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			this.y += (Math.cos(graphicDegs * (Math.PI/180)) * speed);												
			this.x -= (Math.sin(graphicDegs * (Math.PI/180)) * speed);*/
		}
		
		public function Loop(leftButton,rightButton,fireButton,changeWeaponButton = null):void
		{
			aimTurret()
			
			graphicDegs = rotation;
			
			if (graphicDegs < 0)
				graphicDegs += 360;
			
			if (speed >= 0.05)
				speed -= 0.05;
				
			else if (speed <= -0.05)
				speed += 0.05;
				
			else
				speed = 0;
				
				
			if (leftButton == true)
				rotateLeft();
				
			if (rightButton == true)
				rotateRight();
				
			if (changeWeaponButton != null)
				currentWeapon = changeWeaponButton;
				
			if (fireButton == true)
				fire();
				
			canFireCountdown--
			
			if (canFireCountdown <= 0)
				canFire = true
				
			canFireMGCountdown--
			
			if (canFireMGCountdown <= 0)
				canFireMG = true
					
				
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
			
			if (speed == 0)
			{
				if (leftButton == true)
				{
					leftTrack.updatePos(-1);
					rightTrack.updatePos(1);
				}
					
				else if (rightButton == true)
				{
					rightTrack.updatePos(-1);
					leftTrack.updatePos(1);
				}
			}
			
			else
			{
				rightTrack.updatePos(speed);
				leftTrack.updatePos(speed);
			}
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