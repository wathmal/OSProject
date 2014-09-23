class DashBoard{
	public Button start;
	
	public Button reset;

	DashBoard()
	{
		start = cp5.addButton("START")
				   .setPosition(10, 10)
				   .setSize(30,30)
				   .setCaptionLabel("START")
				   ;
		reset = cp5.addButton("RESET")
				   .setPosition(10 + 5 + 30 + 5 + 30, 10)
				   .setSize(30,30)
				   .setCaptionLabel("RESET")
				   ;
	}


}