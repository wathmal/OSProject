final int JOB_WIDGET_PADDING = 10;

class JobPool
{
  private int posx;
  private int posy;
  private int maxJobCount;
  private int top;
  
  Job jobs[];
  Button addButton;
  JobPool(int x, int y) {
  	posx = x;
  	posy = y;
  	top = 0;
    setMaxJobCount();
  	jobs = new Job[maxJobCount];
  	addButton = cp5.addButton("addButton")
  				   .setPosition(posx, height - JOB_WIDGET_HEIGHT - 10)
  				   .setSize(JOB_WIDGET_WIDTH, JOB_WIDGET_HEIGHT)
  				   .setCaptionLabel("[+] Add Job")
  				   .activateBy(ControlP5.RELEASE);
  }

  public void setMaxJobCount()
  {
  	maxJobCount =  ( height - 10 - posy) / (JOB_WIDGET_PADDING + JOB_WIDGET_HEIGHT) -1; // -10 is for bottom padding
  }

  public void push(Job job) {
  	if(top < maxJobCount)
  	{
  		jobs[top++] = job;
  	}
  	render();
  }

  public void kill(int jobid) {
  	int i = 0;
    for(i = 0;i < maxJobCount;i++)
      if(jobs[i] != null && jobs[i].myid == jobid)
        break;
    
    if(jobs[i] != null) {
      jobs[i].hide();
      jobs[i] = null;
      //println("Item Removed");
    }
    
    for(;i < maxJobCount - 1;i++)
      jobs[i] = jobs[i + 1];
  	top--;
  	render();
  	print(maxJobCount + " | ");
  	for (Job j : jobs) {
  		print(j == null ? "null, " : j.jobIdLabel.getName() + ",");
  	}
  	println();
  	//jobs[removedJobIndex].removeJob();
  }

  public void kill(Job job)
  {
  	remove(job.myid);
  }

  public Job getJob(int jobid)
  {
  	for(int i = 0;i < top;i++)
  		if(jobs[i].myid == jobid) {
  			return jobs[i];
  		}	
  	return null;
  }

  public void dispatch(int jobid) {
  	getJob(jobid).state = 1;
  }

  public void freeze(int jobid)
  {
  	getJob(jobid).state = 0;
  }
  
  
  
  public void render()
  {
  	background(0); //reset background to clear any trailing painted pixels in the canvas
  	int cnt = 0;
  	for(int i = 0;i < top;i++)
  		if(jobs[i] != null) {
  			jobs[i].move(posx, posy + i * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING));
  			jobs[i].timeLine.move(posx + JOB_WIDGET_WIDTH + 10, posy + i * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING) );
  			jobs[i].timeLine.render();
  		}
  	// for (Job job : jobs) 
  	// 	if(job != null)
  	// 		job.move(posx, posy + cnt++ * (JOB_WIDGET_HEIGHT + JOB_WIDGET_PADDING));
	addButton.setPosition(posx, height - JOB_WIDGET_HEIGHT - 10);
  }	
  public void move(int x, int y) {
  	posx = x;
  	posy = y;
  	render();
  }
  public int getMaxJobCount() {
    return maxJobCount;
  }

}