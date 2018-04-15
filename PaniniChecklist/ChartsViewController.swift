//
//  ChartsViewController.swift
//  PaniniChecklist
//
//  Created by Stefan Andric on 4/15/18.
//  Copyright © 2018 stefandric. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    var collectedImages = 0
    var duplicates = 0
    var coveragePercentage: Double {
        return Double(100*collectedImages/669)
    }
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = "Collected: \(collectedImages)\nDuplicates: \(duplicates)"
        }
    }
    
    private var collectedColor = UIColor(red: 31/255, green: 188/255, blue: 210/255, alpha: 1/1)
    private var totalColor = UIColor(red: 64/255, green: 84/255, blue: 178/255, alpha: 1/1)

    @IBOutlet weak var chartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createChart()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createChart() {
        var dataEntries: [PieChartDataEntry] = []
        
//        let collectedImages = PieChartDataEntry(value: Double(self.collectedImages), label: "")
        let collectedImages = PieChartDataEntry(value: Double(self.collectedImages), label: "Collected")
        let baseImages = PieChartDataEntry(value: Double(669-self.collectedImages), label: "Left")

        dataEntries.append(collectedImages)
        dataEntries.append(baseImages)
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [collectedColor, totalColor]
        let chartData = PieChartData(dataSet: chartDataSet)
        chartView.data = chartData

        chartView.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.easeInOutCirc)
        chartView.chartDescription = nil
        
        /*
         let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
         let chartData = BarChartData(dataSet: chartDataSet)
         barView.data = chartData
 */
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
