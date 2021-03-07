package 
{
    
    import flash.utils.getTimer;
    import flash.events.Event;
    import flash.display.Sprite;
    import flash.text.TextField;
    
    public class FramerateTracker extends Sprite
    {
        
        // vars
        private var time:int;
        private var prevTime:int = 0;
        private var fps:int;
        private var fps_txt:TextField;
        
        // constructor
        public function FramerateTracker()
        {
            
            //
            fps_txt = new TextField();
			fps_txt.textColor = (0xFFFFFF)
            addChild(fps_txt);
            
            //
            //addEventListener(Event.ENTER_FRAME, getFps);
            
        }
        
        // methods
        public function getFps(e:Event = null):void
        {
            
            //
            time = getTimer();
            fps = 1000 / (time - prevTime);
            
            //
            fps_txt.text = "fps: " + fps;
            
            //
            prevTime = getTimer();
            
            
            
        }
        
        
        
    } // end class
    
} // end package 