class SchedulerJob {
	SchedulerJob() {

	}
	public Job mostUrgentJob()
	{
		Job jb;
		int i;
		//search for the first non-null job reference
		for(i = 0;i < pool.top;i++)
			if(pool.jobs[i] != null && pool.jobs[i].dispatchButton.isOn())
				break;
		//set it as our most urgent job
		jb = pool.jobs[i];
		//start comparing it with the rest to find the most urgent job
		for(;i < pool.top;i++)
		{
			if((pool.jobs[i] != null && pool.jobs[i].dispatchButton.isOn()) && (pool.jobs[i].deadline < jb.deadline))
				jb=pool.jobs[i]; // i'th job is more urgent than the last found job
		}
		return jb;
	}
	public void schedule()
	{
		error("Scheduler called....");
		currentJob = mostUrgentJob();
	}
}
