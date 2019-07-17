//
//  OperationalUtilizationViewController.swift
//  Bthere
//
//  Created by User on 18.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
// דוח ניצול גרפים  
class OperationalUtilizationViewController: NavigationModelViewController,LineChartDelegate{
    var label = UILabel()
    var lineChart: LineChart!
    
    
    //MARK: - Outlet
    
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var viewMiddle: UIView!
    
    @IBOutlet weak var viewTop: UIView!
    
    @IBOutlet weak var viewFromDate: UIView!
    
    @IBOutlet weak var lblFromDate: UILabel!
    
    @IBOutlet weak var viewToDate: UIView!
    
    @IBOutlet weak var lblToDate: UILabel!
    
    
    @IBOutlet weak var dpFromTo: UIDatePicker!
    
   //MARK: - Initial
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapBack: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OperationalUtilizationViewController.goBack))
        viewBack.addGestureRecognizer(tapBack)
       
        dpFromTo.setValue(Colors.sharedInstance.color1, forKeyPath: "textColor")
        dpFromTo.backgroundColor = UIColor.white
        dpFromTo.datePickerMode = .date
        
        
        dpFromTo.addTarget(self, action: #selector(OperationalUtilizationViewController.dataPickerChanged(_:)), for: UIControl.Event.valueChanged)
        
        dpFromTo.isHidden = true
     //   self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-pic-supplier@x1.jpg")!)
        self.view.addBackground()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissDp))
        view.addGestureRecognizer(tap)
        
        let tapOpenDpFrom:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openDpFrom))
        let tapOpenDpTo:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openDpTo))
        viewFromDate.addGestureRecognizer(tapOpenDpFrom)
        viewToDate.addGestureRecognizer(tapOpenDpTo)
        
        // var views: [String: AnyObject] = [:]
        
        //        label.text = "..."
        //        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.textAlignment = NSTextAlignment.Center
        //        self.view.addSubview(label)
        //        views["label"] = label
        
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        
        //array of dots in the axis
        let data: [CGFloat] = [0, 120, 80, 260, 140, 320, 210, 500, 440]
//        let data: [CGFloat] = [0, 10,-30,-40]
        
        // simple line with custom x axis labels
        let xLabels: [String] = ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x"]

        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        
        lineChart.x.labels.visible = true
        lineChart.y.labels.visible = true
        
        lineChart.x.grid.count = 8
        lineChart.y.grid.count = 11
        
        lineChart.x.labels.values = xLabels
      
        lineChart.dots.visible = false
        lineChart.addLine(data)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        
        //views["chart"] = lineChart
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        //        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        let horizontalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.84, constant: 0)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: lineChart, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        view.addConstraint(heightConstraint)
        
        
        //        var delta: Int64 = 4 * Int64(NSEC_PER_SEC)
        //        var time = dispatch_time(DISPATCH_TIME_NOW, delta)
        //
        //        dispatch_after(time, dispatch_get_main_queue(), {
        //            self.lineChart.clear()
        //            self.lineChart.addLine(data2)
        //        });
        
        //        var scale = LinearScale(domain: [0, 100], range: [0.0, 100.0])
        //        var linear = scale.scale()
        //        var invert = scale.invert()
        //        //\\println(linear(x: 2.5)) // 50
        //        //\\println(invert(x: 50)) // 2.5
         self.view.bringSubviewToFront(dpFromTo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    @objc func dismissDp() {
       // view.endEditing(true)
        dpFromTo.isHidden = true
    }
  
    //MARK: - Date Picker
    
    @objc func openDpFrom() {
//        dpFromTo.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
//        dpFromTo.backgroundColor = Colors.sharedInstance.color1
        viewFromDate.tag = 1
        viewToDate.tag = 0
        dpFromTo.isHidden = false
    }
    
    @objc func openDpTo() {
//        dpFromTo.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
//        dpFromTo.backgroundColor = Colors.sharedInstance.color1
        viewFromDate.tag = 0
        viewToDate.tag = 1
        dpFromTo.isHidden = false
    }
    
    @objc func dataPickerChanged(_ datePicker:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let strDate = dateFormatter.string(from: datePicker.date)

        if viewFromDate.tag == 1
        {
            lblFromDate.text = strDate
            viewFromDate.tag = 0
        }
        else
        {
            lblToDate.text = strDate
            viewToDate.tag = 0
        }
        
    }
    
    @objc func goBack() {
        
         let revealController: SWRevealViewController = self.revealViewController()
        
        let ReportsController: ReportViewController = self.storyboard!.instantiateViewController(withIdentifier: "ReportViewController")as! ReportViewController
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: ReportsController)
        revealController.pushFrontViewController(navigationController, animated: true)
        //revealController.revealToggleAnimated(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
