Canvas cc;

public int counter = 0; 
int jobAvailability[] = new int[10];
Job jobs[]; //Array in the job poolf


class JobPool extends Canvas {

  public int maxJobCount; // Number of jobs in the pool
  
  // Constructor
  JobPool()
  {
    maxJobCount = height/JOB_WIDGET_HEIGHT - 1; // Number of jobs = 10
    jobs = new Job[maxJobCount]; // Creating the job pool array of 10
    println("maxJobCount = " + maxJobCount);
    }
  
  // Constructer + maxJobCount 
  JobPool(int maxJobCount)
  {
    this.maxJobCount = maxJobCount;
    jobs = new Job[maxJobCount];
  }
  
  public boolean push(Job job)
  {
    for(int i = 0;i < maxJobCount;i++)
      if(jobs[i] == null) { // Adding the new job to the first available position and return true
        jobs[i] = job;
        createInterface();
        return true;
      }
      return false; // If cant add to the pool return false
  }
  
  // Poping the most urgent job  
  public Job getMostUrgent()
  {
    Job mostUrgentJob = null;
    int i = 0;
    while(i < maxJobCount) {
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
    
  int y;

  public void setup(PApplet theApplet) {
    y = 200;
  }  

  public void draw(PApplet p) {
    p.fill(#171717);
    //p.rect(5, 200, 250, 545, 5);
  } 
  
  // This will create the sub-interface(Left side of the mai interface)
  // using the processes which are created in the 'jobs' array
  public void createInterface(){  
    for(int i = 0 ; i  < maxJobCount; i++){
      
      if(jobs[i]!=null){
        //System.out.println(jobs[i].myid);
       
          jobs[i].move(20,60+(i*60));
          //counter++;
      }
    }
  }
  
  // This will remove the given job from the left sub-interface 
  public void remove(int job_id){
    int i = 0;
    for(i = 0;i < maxJobCount;i++)
      if(jobs[i] != null && jobs[i].myid == job_id)
        break;
    
    if(jobs[i] != null) {
      jobs[i].removeJob();
      //maxJobCount--;  
    }
    
    for(;i < maxJobCount - 1;i++)
      jobs[i] = jobs[i + 1];
    
    background(0);
    createInterface();  
    println("maxJobCount = " + maxJobCount);
  }
  

}
