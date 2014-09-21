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
ControlP5 cp5;

long globalTime;

int Job_next_id;
synchronized int getUniqueJobID()
{
  return Job_next_id++;
}

controlP5.Numberbox redb,greenb,blueb;
JobPool pool = new JobPool();
void setup()
{
  
  size(800,600);
  noStroke();
  cp5 = new ControlP5(this);
  
  cc = new JobPool();
  cc.pre();
  cp5.addCanvas(cc);
  
  background(0);
  
  for(int i = 0;i < 5;i++)
    pool.push(new Job(10 , 20 + (60*i)));
  
    // "Add Job Button"
    cp5.addButton("add_Job")
       .setSize(220, 50)
       .setPosition(10, 540)
       .setCaptionLabel("[+] Add Job");

    Job jobNNN = new Job(0,0);
    Job jobMMM = new Job(0,0);
    pool.push(jobNNN);
    pool.push(jobMMM);
    pool.remove(jobNNN.myid);
   //pool.createInterface();
    // ##############################################################################
    // #########################  TESTING  ##########################################
    /*
    JobPool pool = new JobPool();
    Job job1 = new Job(100,100);
    Job job2 = new Job(100,100);
    Job job3 = new Job(100,100);
    Job job4 = new Job(100,100);
    Job job5 = new Job(100,100);
  
    pool.push(job1);
    pool.push(job2);
    pool.push(job3);
    pool.push(job4);
    pool.push(job5);
  
  
    //pool.removeFromInterface(job3);
    //pool.createInterface();
    pool.removeFromInterface(job4);
    Job job6 = new Job(100,100);
    pool.push(job6);
    */ 
    // #################################################################################
    // ################################################################################# 
  
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
int cnt = 0;

void draw() {
  cnt++;
  for(int i = 0;i < pool.jobCount;i++)
    if(jobs[i] != null)
      jobs[i].percentage.setValue(cnt % 101);
}

public void controlEvent(ControlEvent theEvent) {
  String nm = theEvent.getController().getName();
  Pattern p = Pattern.compile("(\\d+)([dk])");
  Matcher m;
  m = p.matcher(nm);
  if(m.find())
  {
    println("Button " + m.group(2) + " of " + m.group(1) + " job was pressed.");
    pool.remove(Integer.parseInt(m.group(1)));
    
  }
}

