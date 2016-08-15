//
//  ViewController.swift
//  tvCharts
//
//  Created by Mikayel Aghasyan on 8/15/16.
//  Copyright © 2016 HugBit LLC. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var verticalBarChart: BarChartView!
    @IBOutlet weak var horizontalBarChart: HorizontalBarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!

    var data = [(name: String, value: Int)]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initData()
    }
    
    private func initData() {
        data.removeAll()
        data.append((name: "Quarter 1", value: 0))
        data.append((name: "Quarter 2", value: 0))
        data.append((name: "Quarter 3", value: 0))
        data.append((name: "Quarter 4", value: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCharts()
        self.update(false)
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ViewController.updateFromTimer), userInfo: nil, repeats: true)
    }

    private func configureCharts() {
        self.verticalBarChart.leftAxis.axisMinValue = 0
        self.verticalBarChart.leftAxis.axisMaxValue = 1000
        self.verticalBarChart.rightAxis.axisMinValue = 0
        self.verticalBarChart.rightAxis.axisMaxValue = 1000

        self.horizontalBarChart.leftAxis.axisMinValue = 0
        self.horizontalBarChart.leftAxis.axisMaxValue = 1000
        self.horizontalBarChart.rightAxis.axisMinValue = 0
        self.horizontalBarChart.rightAxis.axisMaxValue = 1000

        self.lineChart.leftAxis.axisMinValue = 0
        self.lineChart.leftAxis.axisMaxValue = 1000
        self.lineChart.rightAxis.axisMinValue = 0
        self.lineChart.rightAxis.axisMaxValue = 1000
    }
    
    @objc private func updateFromTimer() {
        self.update(true)
    }
    
    private func update(animated: Bool = true) {
        self.updateValues()
        self.updateChartsData(animated)
    }
    
    private func updateValues() {
        data[0].value = Int(arc4random_uniform(1000))
        data[1].value = Int(arc4random_uniform(1000))
        data[2].value = Int(arc4random_uniform(1000))
        data[3].value = Int(arc4random_uniform(1000))
    }

    private func updateChartsData(animated: Bool = true) {
        self.updateChart(self.verticalBarChart, chartDataType: BarChartData.self, chartDataSetType: BarChartDataSet.self, chartDataEntryType: BarChartDataEntry.self, animated: animated)
        self.updateChart(self.horizontalBarChart, chartDataType: BarChartData.self, chartDataSetType: BarChartDataSet.self, chartDataEntryType: BarChartDataEntry.self, animated: animated)
        self.updateChart(self.pieChart, chartDataType: PieChartData.self, chartDataSetType: PieChartDataSet.self, chartDataEntryType: ChartDataEntry.self, animated: animated)
        self.updateChart(self.lineChart, chartDataType: LineChartData.self, chartDataSetType: LineChartDataSet.self, chartDataEntryType: ChartDataEntry.self, animated: animated)
    }

    private func updateChart<CV: ChartViewBase, CD: ChartData, CDS: ChartDataSet, CDE: ChartDataEntry>(chart: CV, chartDataType: CD.Type, chartDataSetType: CDS.Type, chartDataEntryType: CDE.Type, animated: Bool = true) {
        var entries = [CDE]()
        for (index, item) in self.data.enumerate() {
            entries.append(self.chartDataEntryOfType(chartDataEntryType, index: index, value: Double(item.value)))
        }

        let chartData = chartDataOfType(chartDataType, xVals: self.data.map { $0.name })
        chartData!.dataSets = [chartDataSetOfType(chartDataSetType, yVals: entries, label: "Quarters")]
        chart.data = chartData
        
        if (animated) {
            chart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        } else {
            chart.notifyDataSetChanged()
        }
    }

    private func chartDataOfType<T: ChartData>(entryType: T.Type, xVals: [String?]) -> T? {
        var data: T?
        switch entryType {
        case is BarChartData.Type:
            data = BarChartData() as? T
            break
        case is LineChartData.Type:
            data = LineChartData() as? T
            break
        case is PieChartData.Type:
            data = PieChartData() as? T
            break
        default:
            break
        }
        data?.xVals = xVals
        return data
    }

    private func chartDataSetOfType<T: ChartDataSet>(entryType: T.Type, yVals: [ChartDataEntry], label: String?) -> T {
        let dataSet = T()
        dataSet.yVals = yVals
        dataSet.label = label
        dataSet.colors = ChartColorTemplates.material()
        return dataSet
    }

    private func chartDataEntryOfType<T: ChartDataEntry>(entryType: T.Type, index: Int, value: Double) -> T {
        let entry = T()
        entry.xIndex = index
        entry.value = value
        return entry
    }
}

