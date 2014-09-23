
package ossheduleredf;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.CombinedDomainXYPlot;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.StandardXYItemRenderer;
import org.jfree.data.time.Second;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;

/**
 *
 * @author wathmal
 */
public class chartPanel extends ApplicationFrame implements ActionListener{

    
    /** The number of subplots. */
    public static final int SUBPLOT_COUNT = 5;
    
    /** The datasets. */
    private TimeSeriesCollection[] datasets;
    
    /** The most recent value added to series 1. */
    private double[] lastValue = new double[SUBPLOT_COUNT];

    public chartPanel(String title) {
        super(title);
        
        
        final CombinedDomainXYPlot plot = new CombinedDomainXYPlot(new DateAxis("time"));
        this.datasets = new TimeSeriesCollection[SUBPLOT_COUNT];
        
        for (int i = 0; i < SUBPLOT_COUNT; i++) {
            this.lastValue[i] = 1;
            final TimeSeries series = new TimeSeries("process "+ i, Second.class);
            this.datasets[i] = new TimeSeriesCollection(series);
            final NumberAxis rangeAxis = new NumberAxis("process"+i);
            rangeAxis.setAutoRangeIncludesZero(false);
            final XYPlot subplot = new XYPlot(
                    this.datasets[i], null, rangeAxis, new StandardXYItemRenderer()
            );
            subplot.setBackgroundPaint(Color.lightGray);
            subplot.setDomainGridlinePaint(Color.white);
            subplot.setRangeGridlinePaint(Color.white);
            plot.add(subplot);
        }

        final JFreeChart chart = new JFreeChart("process simulation", plot);
//        chart.getLegend().setAnchor(Legend.EAST);
        chart.setBorderPaint(Color.black);
        chart.setBorderVisible(true);
        chart.setBackgroundPaint(Color.white);
        
        plot.setBackgroundPaint(Color.lightGray);
        plot.setDomainGridlinePaint(Color.white);
        plot.setRangeGridlinePaint(Color.white);
  //      plot.setAxisOffset(new Spacer(Spacer.ABSOLUTE, 4, 4, 4, 4));
        final ValueAxis axis = plot.getDomainAxis();
        axis.setAutoRange(true);
        axis.setFixedAutoRange(60000.0);  // 60 seconds
        
        final JPanel content = new JPanel(new BorderLayout());

        
        final ChartPanel chartPanel = new ChartPanel(chart);
        content.add(chartPanel);
        
        final JPanel buttonPanel = new JPanel(new FlowLayout());
        
        final JButton buttonAll = new JButton("ALL");
        buttonAll.setActionCommand("ADD_ALL");
        buttonAll.addActionListener(this);
        buttonPanel.add(buttonAll);
        
        content.add(buttonPanel, BorderLayout.SOUTH);
        
        
        chartPanel.setPreferredSize(new java.awt.Dimension(500, 470));
        chartPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        setContentPane(content);

    }
    
    public void updateGraph(int index, double value){
        this.datasets[index].getSeries(0).addOrUpdate(new Second(), value);
    }
    
   
    
    public static void main (String a[]){
        chartPanel cp= new chartPanel("simul");
        cp.pack();
        RefineryUtilities.centerFrameOnScreen(cp);
        cp.setVisible(true);
        
        Second s= new Second();
        while(true){
           cp.updateGraph(0, 1);
        }
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getActionCommand().equals("ADD_ALL")) {
            updateGraph(0, 0);
        }
    }
}
