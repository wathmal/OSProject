import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.regex.Pattern; 
import java.util.regex.Matcher; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Scheduler extends PApplet {

class SchedulerJob {
	SchedulerJob() {

	}
	public Job mostUrgentJob()
	{
		Job jb;
		int i;
		//search for the first non-null job reference
		for(i = 0;i < pool.top;i++)
			if(pool.jobs[i] != null && pool.jobs[i].dispatchButton.isOn())
				break;
		//set it as our most urgent job
		jb = pool.jobs[i];
		//start comparing it with the rest to find the most urgent job
		for(;i < pool.top;i++)
		{
			if((pool.jobs[i] != null && pool.jobs[i].dispatchButton.isOn()) && (pool.jobs[i].deadline < jb.deadline))
				jb=pool.jobs[i]; // i'th job is more urgent than the last found job
		}
		return jb;
	}
	public void schedule()
	{
		
		currentJob = mostUrgentJob();
	}
}
/*

Job Class
---------
This class  holds information about a single job. And creates GUI elements to change the parameters of the job
and perform certain operations on the Job (eg. Start/pause/stop)
Public Varialbles
-----------------
int : posx, posy - stores the top, left position coodinate of the Job Controller GUI
int : myid       - stores a Unique Process ID
int : nextReschedule - stores the time that the deadline needs to be rescheduled
int : proccessedTime - The time that the job has been on processor
int : arrivaltime - The time the Job was created and added to the queue
boolean : state - True if the Job is running on processor now, false if not
int : absoluteDeadline - the timestamp of the deadline of this Job
int : completionPercentage - the percentage of time that the Job has been complete

job(int x, int y) - constructor, x and y is the position of the GUI control
getPeriod() - returns the repeat period of the Job
getServiceTime() - return the service time of the Job

*/

final int PERCENTAGE_RADIUS = 20;

class Job
{
  public controlP5.Numberbox period;
  public controlP5.Numberbox serviceTime;
  public controlP5.Knob percentage;
  public controlP5.Textlabel jobIdLabel;
  public controlP5.Button dispatchButton;
  public controlP5.Button killButton;
  TimelineQueue timeLine;

  public int posx;
  public int posy;
  public int myid;
  
  public int deadline; 
  public int nextReschedule;
  public int processedTime;
  public int arrivalTime;
  public int state;
  public float completionPercentage; // = processedTime/serviceTime * 100%
  public boolean fresh;
  
  Job(int x, int y)
  {
    posx = x;
    posy = y;
    deadline = 0;
    processedTime = 0;
    myid = getUniqueJobID();

    fresh = true;

    this.timeLine = new TimelineQueue(posx, posy, TIMELINE_LENGTH, TIMELINE_CELL_WIDTH, JOB_WIDGET_HEIGHT);
    
    
    this.jobIdLabel = cp5.addTextlabel(myid + "")
                         .setPosition(posx, posy)
                         .setText("JOB #" + myid);
    
    this.period = cp5.addNumberbox(myid + "p" )
                 .setPosition(posx + (PERCENTAGE_RADIUS + 25), posy + 13 )
                 .setMin(MIN_PERIOD)
                 .setSize(JOB_WIDTH,JOB_HEIGHT)
                 .setDirection(Controller.HORIZONTAL)
                 .setValue(MIN_PERIOD)
                 .setCaptionLabel("Period");
                 
    this.serviceTime = cp5.addNumberbox(myid + "s")
                       .setPosition(period.getPosition().x + 5 + JOB_WIDTH , posy + 13)
                       .setRange(1,MAX_SERVICE_TIME)
                       .setSize(JOB_WIDTH,JOB_HEIGHT)
                       .setDirection(Controller.HORIZONTAL)
                       .setValue(1)
                       .setCaptionLabel("Service Time");
                       
    this.percentage = cp5.addKnob(myid + "c")
                         .setRange(0,100)
                         .setValue(processedTime)
                         .setPosition(posx, posy + 12)
                         .setRadius(PERCENTAGE_RADIUS)
                         .setShowAngleRange(false)
                         .setLock(false)
                         .setCaptionLabel("");
                         
    this.dispatchButton = cp5.addButton(myid + "d")
                             .setPosition(serviceTime.getPosition().x + JOB_WIDTH + 2, posy + 13)
                             .setSize(JOB_HEIGHT, JOB_HEIGHT)
                             .setCaptionLabel("  >")
                             .setSwitch(true); 
    this.killButton = cp5.addButton(myid + "k")
                         .setPosition(dispatchButton.getPosition().x + JOB_HEIGHT + 2, posy + 13)
                         .setSize(JOB_HEIGHT, JOB_HEIGHT)
                         .setCaptionLabel("  x");
  }
  
  public void move(int x, int y)
  {
    posx = x;
    posy = y;
    this.period.setPosition(posx + (PERCENTAGE_RADIUS + 25), posy + 13 );
    this.serviceTime.setPosition(period.getPosition().x + 5 + JOB_WIDTH , posy + 13);
    this.percentage.setPosition(posx, posy + 12);
    this.dispatchButton.setPosition(serviceTime.getPosition().x + JOB_WIDTH + 2, posy + 13);
    this.killButton.setPosition(dispatchButton.getPosition().x + JOB_HEIGHT + 2, posy + 13);
    this.jobIdLabel.setPosition(posx, posy);
    timeLine.move(posx, posy);
  }
  
  public void hide()
  {
    this.period.hide();
    this.serviceTime.hide();
    this.percentage.hide();
    this.dispatchButton.hide();
    this.killButton.hide();
    this.jobIdLabel.hide();
  }
  public void removeJob(){
    this.period.remove();
    this.serviceTime.remove();
    this.percentage.remove();
    this.dispatchButton.remove();
    this.killButton.remove();
    this.jobIdLabel.remove();
    
  }
  
  public int getPeriod()
  {
    return (int)this.period.getValue();
  }
  
  
  public int getServiceTime()
  {
    return (int)this.period.getValue();
  }
  public void setReady()
  {
    deadline = globalTime + Math.round(period.getValue());
    arrivalTime = globalTime;
  }
  public boolean incProcessedTime()
  {
    this.processedTime++;
    this.percentage.setValue(processedTime/serviceTime.getValue() * 100);
    if(processedTime == serviceTime.getValue())
      return true;
    
    return false;
  }
}

final int JOB_WIDGET_PADDING = 10;

class JobPool
{
  private int posx;
  private int posy;
  private int maxJobCount;
  private int top;
  
  Job jobs[];
  Button addButton;
  JobPool(int x, int y) {
  	posx = x;
  	posy = y;
  	top = 0;
    setMaxJobCount();
  	jobs = new Job[maxJobCount];
  	addButton = cp5.addButton("addButton")
  				   .setPosition(posx, height - JOB_WIDGET_HEIGHT - 10)
  				   .setSize(JOB_WIDGET_WIDTH, JOB_WIDGET_HEIGHT)
  				   .setCaptionLabel("[+] Add Job")
  				   .activateBy(ControlP5.RELEASE);
  }

  public void setMaxJobCount()
  {
  	maxJobCount =  ( height - 10 - posy) / (JOB_WIDGET_PADDING + JOB_WIDGET_HEIGHT) -1; // -10 is for bottom padding
  }

  public void push(Job job) {
  	if(top < maxJobCount)
  	{
  		jobs[top++] = job;
  	}
  	render();
  }

  public void kill(int jobid) {
  	int i = 0;
    for(i = 0;i < maxJobCount;i++)
      if(jobs[i] != null && jobs[i].myid == jobid)
        break;
    
    if(jobs[i] != null) {
      jobs[i].hide();
      jobs[i] = null;
      //println("Item Removed");
    }
    
    for(;i < maxJobCount - 1;i++)
      jobs[i] = jobs[i + 1];
  	top--;
  	render();
  	print(maxJobCount + " | ");
  	for (Job j : jobs) {
  		print(j == null ? "null, " : j.jobIdLabel.getName() + ",");
  	}
  	println();
  	//jobs[removedJobIndex].removeJob();
  }

  public void kill(Job job)
  {
  	remove(job.myid);
  }

  public Job getJob(int jobid)
  {
  	for(int i = 0;i < top;i++)
  		if(jobs[i].myid == jobid) {
  			return jobs[i];
  		}	
  	return null;
  }

  public void dispatch(int jobid) {
  	getJob(jobid).state = 1;
  }

  public void freeze(int jobid)
  {
  	getJob(jobid).state = 0;
  }
  
  
  
  public void render()
  {
  	background(0); //reset background to clear any trailing painted pixels in the canvas
  	int cnt = 0;
  	for(int i = 0;i < top;i++)
  		if(jobs[i] != null) {
  			jobs[i].move(posx, posy + i * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING));
  			jobs[i].timeLine.move(posx + JOB_WIDGET_WIDTH + 10, posy + i * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING) );
  			jobs[i].timeLine.render();
  		}
  	// for (Job job : jobs) 
  	// 	if(job != null)
  	// 		job.move(posx, posy + cnt++ * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING));
	addButton.setPosition(posx, height - JOB_WIDGET_HEIGHT - 10);
  }	
  public void move(int x, int y) {
  	posx = x;
  	posy = y;
  	render();
  }
  public int getMaxJobCount() {
    return maxJobCount;
  }

}




final int MIN_PERIOD = 10; //minimum job cycle duration
final int MAX_SERVICE_TIME = 200; //maximum time for a job on processor
final int JOB_WIDTH = 60;
final int JOB_HEIGHT = 20;

//HEIGHT AND WIDTH OF THE FULL JOB WIDGET
final int JOB_WIDGET_HEIGHT = 50;
final int JOB_WIDGET_WIDTH = 220;

final int TIMELINE_LENGTH = 1030;
final int TIMELINE_CELL_WIDTH = 3;

final int COLOR_BACKGROUND = color(0, 0, 0);
final int COLOR_TIMELINE_RUNNING = color(204, 255, 0);
final int COLOR_TIMELINE_SLEEPING = color(24, 24, 24);
final int COLOR_TIMELINE_PREEMPT = color(255, 0, 0);

final int JOBSTACK_SIZE = 200;

ControlP5 cp5;
JobPool pool;
DashBoard dash;
SchedulerJob sched;
int globalTime;
int Job_next_id;
Job currentJob;
boolean timeRunning;
boolean firstTime;
public synchronized int getUniqueJobID()
{
  return Job_next_id++;
}

public void setup()
{
  
  size(1280,720); //720p for Nexus

  background(0);
  noStroke();

  cp5 = new ControlP5(this);
  pool = new JobPool(10,100);
  dash = new DashBoard();
  sched = new SchedulerJob();  

  
  error(pool.getMaxJobCount() + "");

  Job itemp;
  for(int i = 0;i < 4;i++){
    itemp = new Job(0,0);
    itemp.serviceTime.setValue(30);
    pool.push(itemp);

    // itemp.dispatchButton.setOn();
    // jobDispatch(itemp.myid);
  }
  timeRunning = false;
  firstTime = true;
  currentJob = pool.jobs[0];
    
}
public void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
int cnt = 0;

public void draw() {
  if(timeRunning) {
    globalTime++;
    checkRescheduledJobs();
    if(currentJob != null) {
      currentJob.incProcessedTime();

      error(currentJob.myid + " : " + currentJob.processedTime + "/" + Math.round(currentJob.serviceTime.getValue()));
      if(currentJob.processedTime == Math.round(currentJob.serviceTime.getValue()))
      {
        currentJob.dispatchButton.setOff();
        currentJob.state = 0;

        currentJob.nextReschedule = Math.round(currentJob.period.getValue()) + currentJob.arrivalTime + 1;//update this for a-periodic check
        error("Rescheduling....");

        sched.schedule();
      }
      for(int i = 0;i < pool.top;i++) {
        
        if( pool.jobs[i] == currentJob)
          pool.jobs[i].timeLine.push(1);
        else
          pool.jobs[i].timeLine.push(0);
        
        pool.jobs[i].timeLine.render();
      }
    }
    else {
      error("No Jobs to Run");
      //return;
    }
   
  }

  
}

public void controlEvent(ControlEvent theEvent) {
  String nm = theEvent.getController().getName();
  
  if(nm == "START") {

    if(firstTime)
    {
      firstTime = false;
      //CALL THE SCHEDULER
      sched.schedule();
    }

    timeRunning = !timeRunning;
    theEvent.getController().setCaptionLabel(timeRunning ? "HOLD" : "START");
    error("start pressed");
  }

  if(nm == "RESET")
  {
    reset();
  }
  if(nm == "addButton")
    pool.push(new Job(0,0));
  

  //process events from buttons in the Job Objects

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

public void jobKill(int jobId)
{
  pool.kill(jobId);
}
public void jobDispatch(int jobId) 
{
  Job j = pool.getJob(jobId);
  if(j.fresh) {
    j.setReady();
     error(jobId + " is ready. " + j.arrivalTime + " " + j.deadline) ;
     j.fresh = false;
  }
  sched.schedule();
}

public void reset()
{
  timeRunning = false;
  globalTime = 0;
  currentJob = null;
  dash.start.setCaptionLabel("START");
  for (Job jb : pool.jobs) {
    if(jb != null) {
      jb.serviceTime.setValue(1);
      jb.period.setValue(MIN_PERIOD);
      jb.dispatchButton.setOff();
      jb.timeLine.top = 0;
    }
  }
  background(COLOR_BACKGROUND);
}

public void error(String message) {
  println(message);
}
public void checkRescheduledJobs()
{
  for(int i = 0;i < pool.top;i++)
    if(pool.jobs[i] != null) // && pool.jobs[i].dispatchButton.isOn() is not checked, just in case the user temporarliy holds a repeating pool.jobs
    {
      if(pool.jobs[i].nextReschedule == globalTime)
        jobDispatch(pool.jobs[i].myid);
    } 
}
class DashBoard{
	public Button start;
	
	public Button reset;

	DashBoard()
	{
		start = cp5.addButton("START")
				   .setPosition(10, 10)
				   .setSize(30,30)
				   .setCaptionLabel("START")
				   ;
		reset = cp5.addButton("RESET")
				   .setPosition(10 + 5 + 30 + 5 + 30, 10)
				   .setSize(30,30)
				   .setCaptionLabel("RESET")
				   ;
	}


}
final int QUEUE_LEN = 20;


class TimelineQueue
{
  public int cellWidth;
  public int cellHeight;
  private int cellCount;
  public int len;
  public int posx;
  public int posy;
  public int arr[];
  public int top;
  TimelineQueue(int x, int y, int l)
  {
    arr = new int[QUEUE_LEN];
    top = 0;
    posx = x;
    posy = y;
    len = l;
    cellWidth = 10;
    cellCount = len / cellWidth; 
  }
  TimelineQueue(int x, int y, int l, int cw, int ch)
  {
    //arr = new int[QUEUE_LEN];
    top = 0;
    posx = x;
    posy = y;
    len = l;
    
    cellWidth = cw;
    cellHeight = ch;
    cellCount = len / cellWidth;
    
    arr = new int[cellCount];
  }
  public void render()
  {
      for(int i = 0;i < top;i++)
      {
        if(arr[i] == 0)
          fill(COLOR_TIMELINE_SLEEPING);
        else
          fill(COLOR_TIMELINE_RUNNING);
        
        rect(posx + (top - i) * cellWidth, posy, cellWidth, cellHeight);
        if(arr[i] == 2)
        {
          fill(COLOR_TIMELINE_PREEMPT,127);
          rect(posx + (top - i) * cellWidth + cellWidth - 2, posy, 2, cellHeight);
        }
      }
      
  }
  public void push(int val)
  {
    if(top >= cellCount)
    {
      for(int i = 0;i < cellCount-1;i++)
      {
        arr[i] = arr[i+1];
      }
      top--;    
    }
    //println("Added value" + val + " " + top );
    arr[top++] = val;
    
  }
  public void move(int x, int y)
  {
    posx = x;
    posy = y;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Scheduler" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
