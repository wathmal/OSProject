/* 
 * The MIT License
 *
 * Copyright 2014 krv.
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


public class Job {
    public int serviceTime;// at the job creation
    public int period; // at the job creation
    public int jobId;// at the job creation
    public int nextDeadline; //for repeating jobs // changing
    public int processedTime; // <= service time
    public int arrivalTime;// at the job creation
    public boolean runnable;   //running or not
    public boolean running; 
    public boolean blocked;
    public int absoluteDeadline;
    public float completionPercentage; // processed time  /  service time
    public CPU cpu1_Job;
    
    public Job(){} //no argument constructor
    
    public Job(int period, int serviceTime, int jobId, CPU cp ){
        this.period = period;
        this.serviceTime = serviceTime;
        this.jobId = jobId;
        this.cpu1_Job = cp;                
    }
    
    public Job(int period, int serviceTime, int jobId ){
        
    }
    
    public void updateNextDeadline(){
        if(isRunnable() == true){
            this.nextDeadline = this.absoluteDeadline - cp.getTime();
        }else if(isRunning() == true){
            this.nextDeadline = this.absoluteDeadline - cp.getTime() - (this.serviceTime - this.processedTime) ;
        }
    }
    
    public int getServiceTime() {
        return serviceTime;
    }

    public void setServiceTime(int serviceTime) {
        this.serviceTime = serviceTime;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getNextDeadline() {
        return nextDeadline;
    }

    public void setNextDeadline(int nextDeadline) {
        this.nextDeadline = nextDeadline;
    }

    public int getProcessedTime() {
        return processedTime;
    }

    public void setProcessedTime(int processedTime) {
        this.processedTime = processedTime;
    }

    public int getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(int arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public boolean isRunnable() {
        return runnable;
    }

    public void setRunnable() {
        this.runnable = true;
        this.running = false;
        this.blocked = false;
    }

    public boolean isRunning() {
        return running;
    }

    public void run() {
        this.runnable = false;
        this.running = true;
        this.blocked = false;
    }

    public boolean isBlocked() {
        return blocked;
    }

    public void block() {
        this.runnable = false;
        this.running = false;
        this.blocked = true;
    }

    public float getCompletionPercentage() {
        return completionPercentage;
    }

    public void setCompletionPercentage(float completionPercentage) {
        this.completionPercentage = completionPercentage;
    }
    
    public void suspend(){
        
    }
    
    
}
