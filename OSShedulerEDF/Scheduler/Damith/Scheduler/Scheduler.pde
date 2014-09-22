import controlP5.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

final int MIN_PERIOD = 10; //minimum job cycle duration
final int MAX_SERVICE_TIME = 200; //maximum time for a job on processor
final int JOB_WIDTH = 60;
final int JOB_HEIGHT = 20;

//HEIGHT AND WIDTH OF THE FULL JOB WIDGET
final int JOB_WIDGET_HEIGHT = 50;
final int JOB_WIDGET_WIDTH = 220;

final int TIMELINE_LENGTH = 1050;
final int TIMELINE_CELL_WIDTH = 3;

final color COLOR_BACKGROUNG = color(0, 0, 0);
final color COLOR_TIMELINE_RUNNING = color(204, 255, 0);
final color COLOR_TIMELINE_SLEEPING = color(24, 24, 24);
final color COLOR_TIMELINE_PREEMPT = color(255, 0, 0);

ControlP5 cp5;
JobPool pool;

long globalTime;
int Job_next_id;

synchronized int getUniqueJobID()
{
  return Job_next_id++;
}

void setup()
{
  
  size(1280,720); //720p for Nexus

  // if(frame != null)
  //   frame.setResizable(true); //remove this for Android


  background(0);
  noStroke();

  cp5 = new ControlP5(this);
  pool = new JobPool(10,10);
  
  
  
  println(pool.getMaxJobCount());
  for(int i = 0;i < pool.getMaxJobCount();i++)
    pool.push(new Job(0,0));
  
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
int cnt = 0;

void draw() {
  globalTime++;
  for(int i = 0;i < pool.top;i++) {
    pool.jobs[i].timeLine.push(pool.jobs[i].dispatchButton.isOn() ? 1 : 0);
    pool.jobs[i].timeLine.render();
    //print(pool.jobs[i].dispatchButton.isOn() + " ");
  }
  //println();
}

public void controlEvent(ControlEvent theEvent) {
  String nm = theEvent.getController().getName();
  print(theEvent.getController().getName() + ": ");
  Pattern p = Pattern.compile("(\\d+)([dk])");
  Matcher m;
  m = p.matcher(nm);
  if(m.find())
  {
    if(m.group(2).matches("d"))
      jobDispatch(Integer.parseInt(m.group(1)));
    if(m.group(2).matches("k"))
      jobKill(Integer.parseInt(m.group(1)));
  }
}

void jobKill(int jobId)
{
  pool.kill(jobId);
}
void jobDispatch(int jobId) 
{
  //call scheduler
}
void jobCompleted(Job job)
{

}