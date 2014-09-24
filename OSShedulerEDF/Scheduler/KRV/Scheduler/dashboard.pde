class DashBoard{
	public Button start;
	public float cpu_usage;
	public Button reset;
	public Knob cpuUsage;
	DashBoard()
	{
		start = cp5.addButton("START")
				   .setPosition(10, 10)
				   .setSize(30,30)
				   .setCaptionLabel("START")
				   ;
		reset = cp5.addButton("RESET")
				   .setPosition(start.getPosition().x + 30 + 5, 10)
				   .setSize(30,30)
				   .setCaptionLabel("RESET")
				   ;
		cpu_usage = 0;
		cpuUsage = cp5.addKnob("CPU_USAGE")
					  .setPosition(reset.getPosition().x + 30 + 5, 10)
					  .setRange(0,100)
					  .setRadius(20)
					  .setValue(cpu_usage)
					  .setDragDirection(Knob.HORIZONTAL)
					  ;


	}
	void setCPUUsage() {
		cpu_usage = 0;
		
		for(int i = 0;i < pool.top;i++) {
			if(pool.jobs[i] != null)
				cpu_usage += pool.jobs[i].dispatchButton.isOn() ?  pool.jobs[i].serviceTime.getValue() / pool.jobs[i].period.getValue() : 0;	
		}
		
		cpu_usage = (cpu_usage > 1.0) ? 1.0 : cpu_usage;
		
		cpuUsage.setValue(cpu_usage * 100);
		
		//error("CPU U: " + cpu_usage);
	}
}