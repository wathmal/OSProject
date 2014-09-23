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
int globalTime;
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
  
  size(1280,720); //720p for Nexus

  background(0);
  noStroke();

  cp5 = new ControlP5(this);
  pool = new JobPool(10,100);
  dash = new DashBoard();
  sched = new SchedulerJob();  

  

  error(pool.getMaxJobCount() + "");

  Job itemp;
  for(int i = 0;i < 7;i++){
    itemp = new Job(0,0);
    itemp.serviceTime.setValue(10);
    itemp.period.setValue(600);
    pool.push(itemp);

    // itemp.dispatchButton.setOn();
    // jobDispatch(itemp.myid);
  }
  timeRunning = false;
  firstTime = true;
  currentJob = pool.jobs[0];

  c2 = new TimeLIne();
  c2.pre(); // use cc.post(); to draw on top of existing controllers.
  //cp5.addCanvas(c2); // add the canvas to cp5
    
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
      background(color(24, 24, 24,0));
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

void jobKill(int jobId)
{
  pool.kill(jobId);
}
void jobDispatch(int jobId) 
{
  Job j = pool.getJob(jobId);
  if(j.fresh) {
    j.setReady();
     error(jobId + " is ready. " + j.arrivalTime + " " + j.deadline) ;
     j.fresh = false;
  }
  sched.schedule();
}

void reset()
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

void error(String message) {
  println(message);
}
void checkRescheduledJobs()
{
  for(int i = 0;i < pool.top;i++)
    if(pool.jobs[i] != null) // && pool.jobs[i].dispatchButton.isOn() is not checked, just in case the user temporarliy holds a repeating pool.jobs
    {
      if(pool.jobs[i].nextReschedule == globalTime)
        jobDispatch(pool.jobs[i].myid);
    } 
}