Canvas cc;

public int counter = 0; 
int jobAvailability[] = new int[10];
Job jobs[]; //Array in the job pool


class JobPool extends Canvas {
  
  int y;

  public void setup(PApplet theApplet) {
    y = 200;
  }  

  public void draw(PApplet p) {
    p.fill(100);
    p.rect(5, 50, 250, 545, 15);
  } 
  
  // This will create the sub-interface(Left side of the mai interface)
  // using the processes which are created in the 'jobs' array
  public void createInterface(){  
    
    for(int i = 0 ; i  < jobCount; i ++){
      
      if(jobs[i]!=null){
        //System.out.println(jobs[i].myid);
          jobAvailability[i] = 1;
          jobs[i].move(20,60+(i*60));
          counter++;
      }else{
          jobAvailability[i] = 0;
      }
    }
  }
  
  // This will remove the given job from the left sub-interface 
  public void removeFromInterface(Job job){
    for(int i = 0 ; i<jobCount ; i++){
        if(job.myid == jobs[i].myid ){
            jobs[i].removeJob();
            
            
            if(i+1==jobCount){
               jobs[i] = null;
               jobAvailability[i] = 0;         
            }else{
              System.out.println("j");
              for(int j = i; j < jobCount-1;j++){                
                jobs[j] = jobs[j+1];
                jobAvailability[j] = jobAvailability[j+1];
                System.out.println(jobAvailability[j]);
              }
              
            }
            createInterface();
            break;        
        }
        
    }
    
  }

  

  
  int jobCount; // Number of jobs in the pool
  
  // Constructor
  JobPool()
  {
    jobCount = 10; // Number of jobs = 10
    jobs = new Job[jobCount]; // Creating the job pool array of 10
  }
  
  // Constructer + jobCount 
  JobPool(int jobCount)
  {
    this.jobCount = jobCount;
    jobs = new Job[jobCount];
  }
  
  // Adding new jobs to jobPool
  public boolean push(Job job)
  {
    for(int i = 0;i < jobCount;i++)
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
