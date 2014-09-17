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
    
    int shortestDeadline= jobArray[0].absoluteDeadline;
    
    for(int i=0; i< arrayLength; i++){
      
    }
    
    
  }
  
  
  
}
