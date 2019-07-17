//
//  ReportViewController.swift
//  Bthere
//
//  Created by User on 18.5.2016.
//  Copyright © 2016 Webit. All rights reserved.
//

import UIKit
//ספק קים דוחות
class ReportViewController: NavigationModelViewController,PiechartDelegate,PushReportDelegate {

    @IBOutlet weak var viewTop: UIView!

    @IBOutlet weak var viewButtom: UIView!
    
    @IBOutlet weak var viewMiddle: UIView!
    
    @IBAction func btnFullReports(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SupplierExist", bundle: nil)
        let viewCon:ReportsViewController = storyboard.instantiateViewController(withIdentifier: "ReportsViewController") as! ReportsViewController
        
        viewCon.delegate = self
        self.present(viewCon, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var views: [String: UIView] = [:]
        
//        var error = Piechart.Slice()
//        error.value = 4
//        error.color = UIColor.magentaColor()
//        error.text = "Error"
        
        var fill = Piechart.Slice()
        fill.value = 13.6
        fill.color = UIColor(red: 145/255.0, green: 202/255.0, blue: 215/255.0, alpha: 1.0)
       // fill.text = "Zero"
        
        var empty = Piechart.Slice()
        empty.value = 6
        empty.color = UIColor(red: 221/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
      //  empty.text = "Winner"
        
     let piechartCostumers = Piechart()//לקוחות
        piechartCostumers.delegate = self
        piechartCostumers.title = "176"
        piechartCostumers.activeSlice = 2
        piechartCostumers.slices = [fill,empty]
       piechartCostumers.backgroundColor = UIColor.clear
        
        piechartCostumers.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(piechartCostumers)
        
        
        var fillCostumers = Piechart.Slice()
        fillCostumers.value = 10
        fillCostumers.color = UIColor(red: 243/255.0, green: 147/255.0, blue: 113/255.0, alpha: 1.0)
       // fillCostumers.text = "Zero"
        
        var emptyCostumers = Piechart.Slice()
        emptyCostumers.value = 6
        emptyCostumers.color = UIColor(red: 251/255.0, green: 222/255.0, blue: 204/255.0, alpha: 1.0)
      //  emptyCostumers.text = "Winner"
        let piechartOperationalUtilization = Piechart()//ניצולת תפעולית
        piechartOperationalUtilization.delegate = self
        piechartOperationalUtilization.title = "85%"
        piechartOperationalUtilization.activeSlice = 2
        piechartOperationalUtilization.slices = [fillCostumers,emptyCostumers]
        
        piechartOperationalUtilization.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(piechartOperationalUtilization)
        var fillPayments = Piechart.Slice()
        fillPayments.value = 10
        fillPayments.color = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0)
       // fillPayments.text = "Zero"
        
        var emptyPayments = Piechart.Slice()
        emptyPayments.value = 6
        emptyPayments.color = UIColor(red: 228/255.0, green: 223/255.0, blue: 219/255.0, alpha: 1.0)
      //  emptyPayments.text = "Winner"
        let piechartPayments = Piechart()//תשלום באפליקציה
        piechartPayments.delegate = self
        piechartPayments.title = "1750"
        piechartPayments.activeSlice = 2
        piechartPayments.slices = [fillPayments,emptyPayments]
        
        piechartPayments.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(piechartPayments)
        var fillTurns = Piechart.Slice()
        fillTurns.value = 10
        fillTurns.color = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        //fillTurns.text = "Zero"
        
        var emptyTurns = Piechart.Slice()
        emptyTurns.value = 6
        emptyTurns.color = UIColor(red: 174/255.0, green: 171/255.0, blue: 164/255.0, alpha: 1.0)
       // emptyTurns.text = "Winner"
        let piechartTurns = Piechart()//תורים
        piechartTurns.delegate = self
        piechartTurns.title = "342"
        piechartTurns.activeSlice = 2
        piechartTurns.slices = [fillTurns,emptyTurns]
        
        piechartTurns.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(piechartTurns)
        
      //--------------
        let horizontalConstraint = NSLayoutConstraint(item: piechartCostumers, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: piechartCostumers, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: piechartCostumers, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.5, constant: 0)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: piechartCostumers, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
        view.addConstraint(heightConstraint)
//-------------------
        let horizontalConstraintOperationalUtilization = NSLayoutConstraint(item: piechartOperationalUtilization, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraintOperationalUtilization)
        
        let verticalConstraintOperationalUtilization = NSLayoutConstraint(item: piechartOperationalUtilization, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintOperationalUtilization)
        
        let widthConstraintOperationalUtilization = NSLayoutConstraint(item: piechartOperationalUtilization, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.5, constant: 0)
        view.addConstraint(widthConstraintOperationalUtilization)
        
        let heightConstraintOperationalUtilization = NSLayoutConstraint(item: piechartOperationalUtilization, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
        view.addConstraint(heightConstraintOperationalUtilization)
        //-------------------
        
        let horizontalPiechartPayments = NSLayoutConstraint(item: piechartPayments, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        view.addConstraint(horizontalPiechartPayments)
        let verticalConstraintPiechartPayments = NSLayoutConstraint(item: piechartPayments, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintPiechartPayments)
        
        let widthConstraintPiechartPayments = NSLayoutConstraint(item: piechartPayments, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.5, constant: 0)
        view.addConstraint(widthConstraintPiechartPayments)
        
        let heightConstraintPiechartPayments = NSLayoutConstraint(item: piechartPayments, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
        view.addConstraint(heightConstraintPiechartPayments)
        
        //--------------
        let horizontalConstraintPiechartTurns = NSLayoutConstraint(item: piechartTurns, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraintPiechartTurns)
        
        let verticalConstraintPiechartTurns = NSLayoutConstraint(item: piechartTurns, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraintPiechartTurns)
        
        let widthConstraintPiechartTurns = NSLayoutConstraint(item: piechartTurns, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.width, multiplier: 0.5, constant: 0)
        view.addConstraint(widthConstraintPiechartTurns)
        
        let heightConstraintPiechartTurns = NSLayoutConstraint(item: piechartTurns, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMiddle, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
        view.addConstraint(heightConstraintPiechartTurns)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //      self.view.backgroundColor = UIColor(patternImage: UIImage(named: "client.jpg")!)
        self.view.addBackground()
    }

    func setSubtitle(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return "\(Int(slice.value / total * 100))% \(slice.text)"
    }
    
    func setInfo(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return "\(Int(slice.value))/\(Int(total))"
    }
    
    func PushReport(_ viewCon:UIViewController){
        self.navigationController?.pushViewController(viewCon, animated: true)
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
