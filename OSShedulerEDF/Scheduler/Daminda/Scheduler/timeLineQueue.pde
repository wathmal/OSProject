final int QUEUE_LEN = 20;


class TimelineQueue
{
  public int cellWidth;
  public int cellHeight;
  private int cellCount;
  public int len;
  public int posx;
  public int posy;
  public int arr[];
  public int top;
  TimelineQueue(int x, int y, int l)
  {
    arr = new int[QUEUE_LEN];
    top = 0;
    posx = x;
    posy = y;
    len = l;
    cellWidth = 10;
    cellCount = len / cellWidth; 
  }
  TimelineQueue(int x, int y, int l, int cw, int ch)
  {
    //arr = new int[QUEUE_LEN];
    top = 0;
    posx = x;
    posy = y;
    len = l;
    
    cellWidth = cw;
    cellHeight = ch;
    cellCount = len / cellWidth;
    
    arr = new int[cellCount];
  }
  public void render()
  {
      for(int i = 0;i < top;i++)
      {
        if(arr[i] == 0)
          fill(COLOR_TIMELINE_SLEEPING);
        else
          fill(COLOR_TIMELINE_RUNNING);
        
        rect(posx + (top - i) * cellWidth, posy, cellWidth, cellHeight);
        if(arr[i] == 2)
        {
          fill(COLOR_TIMELINE_PREEMPT,127);
          rect(posx + (top - i) * cellWidth + cellWidth - 2, posy, 2, cellHeight);
        }
      }
      
  }
  public void push(int val)
  {
    if(top >= cellCount)
    {
      for(int i = 0;i < cellCount-1;i++)
      {
        arr[i] = arr[i+1];
      }
      top--;    
    }
    //println("Added value" + val + " " + top );
    arr[top++] = val;
    
  }
  public void move(int x, int y)
  {
    posx = x;
    posy = y;
  }
}

