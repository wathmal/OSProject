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
    
    // var shortestDeadline is the array index of the shortest deadline process.
    int shortestDeadline= jobArray[0].absoluteDeadline;
    
    for(int i=1; i< arrayLength; i++){
      if(shortestDeadline > jobArray[i].absoluteDeadline ){
        absoluteDeadline= jobArray[i].absoluteDeadline;
      }
    }
    
    pool.getJobArray()[shortestDeadline].state= true;
    
  }
  
  
  
}
