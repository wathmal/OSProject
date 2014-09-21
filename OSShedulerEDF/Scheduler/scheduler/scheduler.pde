class Scheduler{
  JobPool pool;
  Job jobArray;
  
  Scheduler(JobPool jobPool){
    pool= jobPool;
    
  }
  
  void initJobArrray(){
    jobArray= pool.jobs;
  }
  
  /*
   * scheduler will change the state of the process.
   * & set the state of current process to false.
   */
  public void runScheduler(){
    initJobArray();
    int arrayLength= jobArray.length;
    
    int shortestDeadline= jobArray[0].absoluteDeadline;
    
    for(int i=0; i< arrayLength; i++){
      
    }
    
  }  
}//end scheduler class
