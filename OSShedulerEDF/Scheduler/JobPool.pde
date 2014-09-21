class JobPool {
  public Job jobs[];
  int jobCount;
  JobPool()
  {
    jobCount = 100;
    jobs = new Job[100];
    
  }
  JobPool(int jobCount)
  {
    this.jobCount = jobCount;
    jobs = new Job[jobCount];
  }
  public boolean push(Job job)
  {
    for(int i = 0;i < jobCount;i++)
      if(jobs[i] == null) {
        jobs[i] = job;
        return true;
      }
      return false;
  }
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

