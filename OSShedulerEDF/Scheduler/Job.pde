class Job
{
  public controlP5.Numberbox period;
  public controlP5.Numberbox serviceTime;
  
  public int posx;
  public int posy;
  public int myid;
  
  public int nextDeadline; //for repeating jobs
  public int proccessedTime;
  public int arrivalTime;
  public boolean state;
  public int absoluteDeadline;
  public float completionPercentage; // = processedTime/serviceTime * 100%
  
  
  Job(int x, int y)
  {
    posx = x;
    posy = y;
    nextDeadline = -1;
    procesorTime = 0;
    myid = getUniqueJobID();
    /*
      ADDITIONAL UI ELEMENTS TODO
      ----------------------------
      JOB DISPATCH BUTTON (>)
      JOB HALT BUTTON (x)
      JOB COMPLETION PERCENTAGE LABEL
      JOB ID LABEL
      
      BACKGROUND BOX
      
      CREATED
      -------
      SERVICE TIME NUMBER BOX
      DEADLINE NUMBER BOX
      
    */
    this.period = cp5.addNumberbox(myid + "p" )
                 .setPosition(posx, posy)
                 .setMin(MIN_PERIOD)
                 .setSize(JOB_WIDTH,JOB_HEIGHT)
                 .setDirection(Controller.HORIZONTAL)
                 .setValue(MIN_PERIOD)
                 .setCaptionLabel("Job #" + myid + " period");
    this.serviceTime = cp5.addNumberbox(myid + "s")
                       .setPosition(posx + 10 + JOB_WIDTH , posy)
                       .setRange(0,MAX_SERVICE_TIME)
                       .setSize(JOB_WIDTH,JOB_HEIGHT)
                       .setDirection(Controller.HORIZONTAL)
                       .setValue(0)
                       .setCaptionLabel("Job #" + myid + " service");
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

