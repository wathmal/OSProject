/*

Job Class
---------
This class  holds information about a single job. And creates GUI elements to change the parameters of the job
and perform certain operations on the Job (eg. Start/pause/stop)
Public Varialbles
-----------------
int : posx, posy - stores the top, left position coodinate of the Job Controller GUI
int : myid       - stores a Unique Process ID
int : nextDeadLine - [REFINE THIS]
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
  
  public int nextDeadline; //for repeating jobs
  public int processedTime;
  public int arrivalTime;
  public int state;
  public int absoluteDeadline;
  public float completionPercentage; // = processedTime/serviceTime * 100%
  
  
  Job(int x, int y)
  {
    posx = x;
    posy = y;
    nextDeadline = -1;
    processedTime = 0;
    myid = getUniqueJobID();

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
                       .setRange(0,MAX_SERVICE_TIME)
                       .setSize(JOB_WIDTH,JOB_HEIGHT)
                       .setDirection(Controller.HORIZONTAL)
                       .setValue(0)
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

}

