import controlP5.*;

final int MIN_PERIOD = 10; //minimum job cycle duration
final int MAX_SERVICE_TIME = 200; //maximum time for a job on processor
final int JOB_WIDTH = 100;
final int JOB_HEIGHT = 14;
ControlP5 cp5;

long globalTime;

int Job_next_id;
synchronized int getUniqueJobID()
{
    return Job_next_id++;
}

class JobPool {
  public Job jobs[];
  int jobCount;
  JobPool()
  {
    jobCount = 100;
    jobs = new Job[100];
    
  }
  JobPool(int jobCount)
  {
    this.jobCount = jobCount;
    jobs = new Job[jobCount];
  }
  public boolean push(Job job)
  {
    for(int i = 0;i < jobCount;i++)
      if(jobs[i] == null) {
        jobs[i] = job;
        return true;
      }
      return false;
  }
  public Job getMostUrgent()
  {
    Job mostUrgentJob = null;
    int i = 0;
    while(i < jobCount) {
      if(jobs[i] != null) {
        if(mostUrgentJob == null)
          mostUrgentJob = jobs[i];
        else if(mostUrgentJob.nextDeadline > jobs[i].nextDeadline)
          mostUrgentJob = jobs[i];
      }
      i++;
    }
    return mostUrgentJob;
  }
  public void remove(int id)
  {
    int i = -1;
    while(++i < jobCount)
    {
      if(jobs[i] != null && jobs[i].myid == id) {
        jobs[i] = null;
        return;
      }
    }
  }
  public void printPool()
  {
    int i = -1;
    while(++i < jobCount)
      if(jobs[i] != null)
        print(jobs[i].myid +"("+ jobs[i].getPeriod()+")"  + " ");
     println();
  }
}


int r, g, b;

controlP5.Numberbox redb,greenb,blueb;
JobPool pool = new JobPool();
void setup()
{
  size(800,480);
  noStroke();
  
  cp5 = new ControlP5(this);
  /*
  redb = cp5.addNumberbox("redn")
  .setPosition(100,60)
  .setSize(100,14)
  .setRange(0,255)
  .setScrollSensitivity(1)
  .setDirection(Controller.HORIZONTAL)
  .setValue(20);
  
  greenb = cp5.addNumberbox("greenn")
  .setPosition(100,120)
  .setSize(100,14)
  .setRange(0,255)
  .setScrollSensitivity(1)
  .setDirection(Controller.HORIZONTAL)
  .setValue(20);
  
  blueb = cp5.addNumberbox("bluen")
  .setPosition(100,180)
  .setSize(100,14)
  .setRange(0,255)
  .setScrollSensitivity(1)
  .setDirection(Controller.HORIZONTAL)
  .setValue(20);*/
  //Job myjob = new Job(100,240);
  
  c2 = new TimeLIne();
  c2.pre(); // use cc.post(); to draw on top of existing controllers.
  cp5.addCanvas(c2); // add the canvas to cp5
  
  
  
  for(int i = 0;i < 10;i++)
    pool.push(new Job(10 , 10 + (36*i)));
  background(0);
  c3 = new Timing_Diagram_Queue(pool.jobs[0]);
  c3.pre(); // use cc.post(); to draw on top of existing controllers.
  cp5.addCanvas(c3); // add the canvas to cp5
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil);
}
  
void draw() {
  pool.jobs[0].proccessedTime++;
  globalTime++;
  background(0);
}


