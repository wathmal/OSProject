import controlP5.*;

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
  size(800,480);
  noStroke();
  cp5 = new ControlP5(this);
  background(0);
  for(int i = 0;i < 5;i++)
    pool.push(new Job(10 , 20 + (60*i)));
  cp5.addButton("add_Job")
     .setSize(220, 50)
     .setPosition(10, 20 + 300)
     .setCaptionLabel("[+] Add Job");
  
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
  
void draw() {

}


