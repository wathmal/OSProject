class Scheduler{
  JobPool pool;
  Job jobArray;
  
  // reference of the JobPool should be passed.
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
    
    // var shortestDeadline is the array index of the shortest deadline process.
    int shortestDeadline= jobArray[0].absoluteDeadline;
    
    // find the job with the shortest deadline.
    for(int i=1; i< arrayLength; i++){
      if(shortestDeadline > jobArray[i].absoluteDeadline ){
        absoluteDeadline= jobArray[i].absoluteDeadline;
      }
    }
    
    /*
     * find the currently running job
     * and if currently running job and the shortest deadline job is not the same;
     * set current job state false;
     * shortest deadline job state true.
     */
    for(int i=1; i< arrayLength; i++){
      if(jobArray[i].state = true && jobArray[shortestDeadline] != jobArray[i]){
        pool.jobs[i].state= false;
        pool.jobs[shortestDeadline].state= true;
      }
      else{
        // currently running jo is the shortest deadline.
        // nothing to change
      }
    }
    
    
    
  }
  
  
  
}
