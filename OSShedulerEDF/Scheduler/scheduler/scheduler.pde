class Scheduler{
  JobPool pool;
  Job jobArray;
  
  Scheduler(JobPool jobPool){
    pool= jobPool;
    
  }
  
  void initJobArrray(){
    jobArray= pool.getJobArray();
  }
  
  public void runScheduler(){
    initJobArray();
    int arrayLength= jobArray.length;
    
    
    
    
  }
  
  
  
}
