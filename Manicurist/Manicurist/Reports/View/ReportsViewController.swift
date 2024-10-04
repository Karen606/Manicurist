//
//  ReportsViewController.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 30.09.24.
//

import UIKit
import Combine
import FSCalendar
import PieCharts

class ReportsViewController: UIViewController {

//    @IBOutlet weak var reportsCollectionView: UICollectionView!
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var chart: PieChart!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var factIncomeLabel: UILabel!
    @IBOutlet weak var incomeProgress: ProgressView!
    @IBOutlet weak var IncomeExpenseeLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var cancelRecords: UILabel!
    @IBOutlet weak var cancelRecordsProgress: ProgressView!
    @IBOutlet weak var rentLabel: UILabel!
    @IBOutlet weak var toolsLabel: UILabel!
    @IBOutlet weak var materialsLabel: UILabel!
    private let viewModel = ReportsViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
//        self.chart.backgroundColor = .clear
    }
    
    func setupUI() {
        setNavigationCancelButton()
        setNavigationMenuButton()
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.layer.cornerRadius = 20
        self.chart.clear()
//        self.chart.outerRadius = 39
//        self.chart.innerRadius = 39
//        self.chart.models = [PieSliceModel(value: 500, color: #colorLiteral(red: 0.9529411765, green: 0.7450980392, blue: 0.8941176471, alpha: 1)), PieSliceModel(value: 200, color: #colorLiteral(red: 0.7764705882, green: 0.968627451, blue: 0, alpha: 1)), PieSliceModel(value: 100, color: #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1))]
        
    }
    
    func subscribe() {
        viewModel.$reportModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] report in
                guard let self = self else { return }
                self.periodLabel.text = "\(dateFormatter(date: viewModel.startDate) ?? "") - \(dateFormatter(date: viewModel.endDate) ?? "")"
                self.incomeLabel.text = "\(report.income ?? 0)$"
                self.factIncomeLabel.text = "Fact \((report.income ?? 0) - (report.expenses ?? 0))$"
                self.IncomeExpenseeLabel.text = "Expenses \(report.expenses ?? 0)$"
                self.recordLabel.text = "\(report.records ?? 0)"
                self.cancelRecords.text = "\(report.cancelRecords ?? 0)"
                var reportCount = 1
                if report.records == 0 {
                    reportCount = 1
                } else {
                    reportCount = report.records ?? 1
                }
                self.cancelRecordsProgress.progress = (Float(report.cancelRecords ?? 0) / Float(reportCount))
                self.rentLabel.text = "\(report.rent ?? 0)$"
                self.toolsLabel.text = "\(report.tools ?? 0)$"
                self.materialsLabel.text = "\(report.materials ?? 0)$"
                self.chart.clear()
                self.chart.models = [PieSliceModel(value: report.rent ?? 0, color: #colorLiteral(red: 0.9529411765, green: 0.7450980392, blue: 0.8941176471, alpha: 1)), PieSliceModel(value: report.tools ?? 0, color: #colorLiteral(red: 0.7764705882, green: 0.968627451, blue: 0, alpha: 1)), PieSliceModel(value: report.materials ?? 0, color: #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1))]
            }
            .store(in: &cancellables)
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func dateFormatter(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func selectedPeriod() {
        calendarView.isHidden = true
        guard let startDate = calendarView.selectedDates.min(), let endDate = calendarView.selectedDates.max() else { return }
        if let start = dateFormatter(date: startDate), let end = dateFormatter(date: endDate) {
            periodLabel.text = "\(start) - \(end)"
        }
    }
    @IBAction func addExpenses(_ sender: UIButton) {
        let expensesVC = ExpensesViewController(nibName: "ExpensesViewController", bundle: nil)
        expensesVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        self.navigationController?.pushViewController(expensesVC, animated: true)
    }
    
    @IBAction func choosePeriod(_ sender: UIButton) {
        calendarView.isHidden.toggle()
    }
    
    deinit {
        viewModel.clear()
    }
    
}

extension ReportsViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dates = [Date]()
        if calendar.selectedDates.count == 2 {
            if calendar.selectedDates.first! > calendar.selectedDates.last! {
                dates = calendar.selectedDates.reversed()
            } else {
                dates = calendar.selectedDates
            }
            let range = datesRange(from: dates.first!, to: dates.last!)
            for d in range {
                calendar.select(d)
            }
        } else if calendar.selectedDates.count > 2 {
            for d in calendar.selectedDates {
                if d != date {
                    calendar.deselect(d)
                }
            }
        }
        if calendar.selectedDates.count > 1 {
            self.selectedPeriod()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if !calendar.selectedDates.isEmpty {
            calendar.selectedDates.forEach({ calendar.deselect($0) })
            calendar.select(date)
        }
        if calendar.selectedDates.count > 1 {
            self.selectedPeriod()
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if calendar.selectedDates.count == 1 && calendar.selectedDates[0] == date {
            selectedPeriod()
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return Date() >= date
    }
}


class ProgressView: UIProgressView {
    
    var customHeight: CGFloat = 10.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = customHeight
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Apply the transformation to change the height
        let scale = customHeight / intrinsicContentSize.height
        transform = CGAffineTransform(scaleX: 1, y: scale)
    }
}
