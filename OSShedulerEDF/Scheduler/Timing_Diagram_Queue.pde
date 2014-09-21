Canvas c3;

class Timing_Diagram_Queue extends Canvas{

  public int posx;
  public int posy;
  public Job queued_job;
  public int progress[]; //may or may not be used
 
  
public Timing_Diagram_Queue(Job related_Job){
        queued_job = related_Job;
        posy = queued_job.posy;
        
}

public Timing_Diagram_Queue(){
        
}

  
  public void setup(PApplet theApplet) {
   
  }  
  
  public void timeline(){
  }

  
  public void draw(PApplet p) {
    posx = (int)globalTime;
    p.fill(255,229,77);
    if((queued_job.state || true)  ){
      int widthy =  queued_job.proccessedTime;      
      p.rect(JOB_WIDTH*2+20-queued_job.proccessedTime+posx-queued_job.arrivalTime, posy, widthy, JOB_HEIGHT);
    }
  }//end draw method 
} 

