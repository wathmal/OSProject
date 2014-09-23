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

import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OSShedulerEDF implements Runnable {

    private Queue runnableQueue;
    private Queue blockedQueue;
    private Queue runningQueue;
    public CPU cpu1;

    // public 
    public OSShedulerEDF() {
        runnableQueue = new Queue(); //add new items to this queue and upon user
        //request move to runningQueue
        blockedQueue = new Queue();
        runningQueue = new Queue();
    }

    public OSShedulerEDF(CPU cp) {
        runnableQueue = new Queue(); //add new items to this queue and upon user
        //request move to runningQueue
        blockedQueue = new Queue();
        runningQueue = new Queue();
        cpu1 = cp;
    }

    public boolean runningToBlocked(int id) {
        Job temp = runningQueue.jobs.get(id);
        temp.block();
        runningQueue.jobs.remove(id);
        blockedQueue.jobs.add(temp);
        return true;
    }

    public boolean blockedToRunning(int id) {
        Job temp = blockedQueue.jobs.get(id);
        temp.run();
        blockedQueue.jobs.remove(id);
        runningQueue.jobs.add(temp);
        return true;
    }

    public boolean runnableToRunning() {
        Job temp = runnableQueue.getEDFJob();
        temp.run();
        runnableQueue.remove(temp);
        runningQueue.add(temp);
        return true;
    }

    public boolean swapBetweenRunninBlocked(Job o) {
        if (o.isRunning()) {
            runningToBlocked(o.getJobId());
        } else if (o.isBlocked()) {
            blockedToRunning(o.getJobId());
        }
        return true;
    }

    public boolean addNewJob(Job newJob) {
        newJob.setRunnable();
        return runnableQueue.add(newJob);
    }

    public void schedule() throws InterruptedException {
        for (Iterator iterator = runningQueue.iterator(); iterator.hasNext();) {
            Job next = (Job) iterator.next();
            if (runnableQueue.getQueueProcessUtilization() > 50) {
                System.out.println("Full utilization");
            } else {
                Job temp = runningQueue.getEDFJob();
                for (int i = 0; i < temp.serviceTime; i++) {
                    temp.processedTime++;
                    temp.updateCompletionPersentage();
                    temp.updateAbsoluteDeadline();
                    temp.updateNextDeadline();
                }
                runnableToRunning();
                //Thread.sleep(temp.serviceTime);
                runningQueue.setQueueProcessUtilization();
            }
        }
    }

    @Override
    public void run() {
        while (true) {
            try {
                schedule();
                Thread.sleep(500);
            } catch (InterruptedException ex) {
                Logger.getLogger(OSShedulerEDF.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }

}
