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

final int TIMELINE_LENGTH = 1030;
final int TIMELINE_CELL_WIDTH = 3;

final color COLOR_BACKGROUND = color(0, 0, 0);
final color COLOR_TIMELINE_RUNNING = color(204, 255, 0);
final color COLOR_TIMELINE_SLEEPING = color(24, 24, 24);
final color COLOR_TIMELINE_PREEMPT = color(255, 0, 0);

final int JOBSTACK_SIZE = 200;



ControlP5 cp5;
JobPool pool;
DashBoard dash;
SchedulerJob sched;
PFont f; 

boolean eventInterruptsOff;

int globalTime;
int unscaledGlobalTime;
int timescale;
int Job_next_id;
Job currentJob;
boolean timeRunning;
boolean firstTime;
synchronized int getUniqueJobID()
{
  return Job_next_id++;
}

void setup()
{
  
  size(1280,650); //720p for Nexus

  background(0);
  noStroke();

  cp5 = new ControlP5(this);
  pool = new JobPool(10,100);
  dash = new DashBoard();
  sched = new SchedulerJob();  
  f = createFont("Arial",16,true); // STEP 3 Create Font
  
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
  
  timescale = 1;

  firstTime = true;
  currentJob = pool.jobs[0];
    
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
int cnt = 0;

void draw() {
  if(timeRunning) {
    unscaledGlobalTime++;
    globalTime = unscaledGlobalTime/timescale;
    checkRescheduledJobs();
    dash.setCPUUsage();
    if(currentJob != null) {
      currentJob.incProcessedTime();

      error(currentJob.myid + " : " + currentJob.processedTime + "/" + Math.round(currentJob.serviceTime.getValue()));
      if(currentJob.serviceTime.getValue() - currentJob.processedTime < 0.1)
      {
        
        currentJob.state = 0;
        currentJob.nextReschedule = Math.round(currentJob.period.getValue()) + currentJob.arrivalTime + 1;//update this for a-periodic check
        currentJob.processedTime = 0; // reset processedTime

        error(globalTime + " Rescheduled with next reschedule at " + currentJob.nextReschedule );
        currentJob.dispatchButton.setOff(); // this will indirectly trigger the scheduler

        //sched.schedule(); not needed anymore because scheduler is triggered by currentJob.dispatchButton.setOff() 
      }
      
    }
    else {
      error( globalTime + " No Jobs to Run");
      //return;
    }
    
    for(int i = 0;i < pool.top;i++) {
        
        if(pool.jobs[i] == currentJob)
          pool.jobs[i].timeLine.push(1);
        else
          pool.jobs[i].timeLine.push(0);
        
        pool.jobs[i].visualizeDeadline();
        pool.jobs[i].timeLine.render();
      }
  }

  //finally draw the timeline numbers
  TimeScaler();
  
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
    if(m.group(2).matches("d")) {
      if(!eventInterruptsOff) // prevents recurring dispatch calls when period > service time
        jobDispatch(Integer.parseInt(m.group(1)));
    }
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
  Job j = pool.getJob(jobId);
  if(j.period.getValue() < j.serviceTime.getValue()) {
    eventInterruptsOff = true;
    j.period.setValue(j.serviceTime.getValue());
    j.dispatchButton.setOff();
    eventInterruptsOff = false;
  }
  if(j.fresh) {
    j.setReady();
     error(jobId + " is ready. " + j.arrivalTime + " " + j.deadline) ;
     j.fresh = false;
  }
  dash.setCPUUsage();
  sched.schedule();
}

void reset()
{
  timeRunning = false;
  unscaledGlobalTime = 0;
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

void error(String message) {
  println(message);
}
void checkRescheduledJobs()
{
  for(int i = 0;i < pool.top;i++)
    if(pool.jobs[i] != null) // && pool.jobs[i].dispatchButton.isOn() is not checked, just in case the user temporarliy holds a repeating pool.jobs
    {
      if(pool.jobs[i].nextReschedule == globalTime) {
        pool.jobs[i].setReady();
        pool.jobs[i].processedTime = 0; // reset processedTime
        pool.jobs[i].dispatchButton.setOn(); // this will call the jobDipatch method 
        //jobDispatch(pool.jobs[i].myid);
        error(pool.jobs[i].myid + " was dispatched with deadline" + pool.jobs[i].deadline);
      }

    } 
}


void TimeScaler(){
  fill(0);
  rect(0,pool.posy-10, width,10);
  rect(0,pool.posy+pool.top*(JOB_WIDGET_HEIGHT+JOB_WIDGET_PADDING)-JOB_WIDGET_PADDING, width,10);
  fill(50,50,50);     
  for(int i = 0 ; i < 500 ; i++){
    text(i,JOB_WIDGET_WIDTH+globalTime*3-30*i,100);
    text(i,JOB_WIDGET_WIDTH+globalTime*3-30*i,pool.posy+pool.top*(JOB_WIDGET_HEIGHT+JOB_WIDGET_PADDING));
  }
  fill(0);
  rect(0,pool.posy-10, JOB_WIDGET_WIDTH,10);
  rect(0,pool.posy+pool.top*(JOB_WIDGET_HEIGHT+JOB_WIDGET_PADDING)-JOB_WIDGET_PADDING, JOB_WIDGET_WIDTH,10);
}