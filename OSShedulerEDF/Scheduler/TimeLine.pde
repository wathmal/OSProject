Canvas c2;

class TimeLIne extends Canvas{
  
  int x;//= JOB_WIDTH*2+20;
 
  public void setup(PApplet theApplet) {
  }  
  
  public void timeline(){
  } 
    
  Textlabel myTextlabelA;
  
  public void draw(PApplet p) {
    
    x = JOB_WIDTH*2+20+(int)globalTime;
    for( Integer i = 0,j = 0 ; i < 50000 ;j++, i +=10){
      if(j%5==0){ 
        p.fill(255,40,40);
        rect(x-i,10, 2,20);              //top long scale indicators
        p.text(i, x-i,40);              //top bar  time on timeline
        
        rect(x-i+0.5,10, 0.5,height-50); // top long scale vertical indicators accross the screen
         
         
        p.text(i, x-i,height-60);        //bottom bar  time on timeline       
        rect(x-i,height-50, 2,20);       //bottom long scale indicators
      }else{
        p.fill(255,40,120);            
        rect(x-i,10, 2,10);              //top small scale indicators        
        rect(x-i,height-40, 2,10);       //bottom small scale indicators
      }
    
    }
    p.fill(0);  //black colour
    rect(0,0, JOB_WIDTH*2+20,height);//black area at left for covering
  } 
  
} 
