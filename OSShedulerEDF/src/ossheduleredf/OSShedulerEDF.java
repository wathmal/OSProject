/* 
 * The MIT License
 *
 * Copyright 2014 Aureole.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package ossheduleredf;


public class OSShedulerEDF implements Runnable{

    public Queue runnableQueue;
    public Queue blockedQueue;
    public Queue runningQueue;
    
    public OSShedulerEDF(){
        runnableQueue = new Queue(); //add new items to this queue and upon user
                                     //request move to runningQueue
        blockedQueue = new Queue();
        runningQueue = new Queue();
    }

    public boolean runningToBlocked(int id){
        Job temp = runningQueue.jobs.get(id);
        runningQueue.jobs.remove(id);
        blockedQueue.jobs.add(temp);
        return true;
    }
    
    public boolean blockedToRunning(int id){
        Job temp = blockedQueue.jobs.get(id);
        blockedQueue.jobs.remove(id);
        runningQueue.jobs.add(temp);
        return true;
    }
    
    public boolean swapBetweenRunninBlocked(Job o){
       if( o.isRunning()){
        runningToBlocked(o.getJobId());
       }else if(o.isIoBlocked()){
         blockedToRunning(o.getJobId());
       }
        return true;
    }
    
    @Override
    public void run() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    
    
    
        
}
