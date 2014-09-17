import controlP5.*;

final int MIN_PERIOD = 10; //minimum job cycle duration
final int MAX_SERVICE_TIME = 200; //maximum time for a job on processor
final int JOB_WIDTH = 100;
final int JOB_HEIGHT = 34;
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
  for(int i = 0;i < 10;i++)
    pool.push(new Job(10 , 20 + (36*i)));
  background(0);
  
}
void wait(int mil)
{
  int curtime = millis();
  while(millis() - curtime >= mil)
  ;
}
  
void draw() {

}


