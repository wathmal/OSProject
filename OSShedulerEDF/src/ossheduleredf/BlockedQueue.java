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

import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author krv
 */
public class BlockedQueue {
    public ArrayList<Job> jobs;
    public int earliestDeadlineJobid;
    
    public BlockedQueue() {
        this.jobs = new ArrayList<>();
        earliestDeadlineJobid = 0;
    }

    public boolean add(Job e) {
        boolean temp = jobs.add(e);
        updateED();
        return temp;
    }

    public Object poll() {
        throw new UnsupportedOperationException("Not supported yet.");    // To change body of generated methods, choose Tools | Templates.
    }

    public int size() {
        return jobs.size();
    }

    public boolean isEmpty() {
        return jobs.isEmpty();
    }

    public boolean contains(Job o) {
        return jobs.contains(o);
    }

    public Iterator iterator() {
        return jobs.iterator();
    }

    public Object[] toArray() {
        return jobs.toArray();
    }

    public boolean remove(Job o) {
        boolean temp = jobs.remove(o);
        updateED();
        return temp;
    }

    public void clear() {
        jobs.clear();
        earliestDeadlineJobid = 0;
    }
    
    public void updateED(){
        int ED = Integer.MAX_VALUE;
        for (Job job : jobs) {
            if(ED > job.getNextDeadline() ){
                ED = job.getNextDeadline();
                earliestDeadlineJobid = job.getJobId();
            }
        }
    }
}
