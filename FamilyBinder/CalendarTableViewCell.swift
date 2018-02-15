//
//  CalendarTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class Selection {
    var date: Date = Date()
    var mealType: MealType?
}

protocol SelectDayDelegate : class {
    func dayCollectionCellSelected(selectedDay: Selection)
    func dayCollectionCellDeselected(deselectedDay: Selection)
}

class CalendarTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var days = [Date]()
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var lblMonth1: UILabel!
    @IBOutlet weak var lblMonth2: UILabel!
    @IBOutlet var lblMonth1ConLeft: NSLayoutConstraint!
    @IBOutlet var lblMonth1ConCenter: NSLayoutConstraint!
    weak var delegate: SelectDayDelegate?
    
    func initWithModel(days: [Date]){
        self.days = days
        self.collectionView.frame.size.width = self.frame.size.width - 70
        updateMonthLabels()
        self.collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDayCollectionViewCell
        cell.initWithModel(day: days[indexPath.row])
        return cell
    }
    
    func tableRowSelected(indexOfSelected: Int){
        let indexOfSelected = IndexPath(row: indexOfSelected, section: 0)
        collectionView.selectItem(at: indexOfSelected, animated: true, scrollPosition: [])
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexOfSelected) as! CalendarDayCollectionViewCell
//        cell.isSelected = true
//        cell.selectCell()
    }
    
    func tableRowDeselected(indexOfDeselected: Int) {
        let indexOfDeselected = IndexPath(row: indexOfDeselected, section: 0)
        collectionView.deselectItem(at: indexOfDeselected, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDayCollectionViewCell!
        cell?.isSelected = true
        
        let newSelection = Selection()
        newSelection.date = days[indexPath.row]
        delegate?.dayCollectionCellSelected(selectedDay: newSelection)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDayCollectionViewCell!
        cell?.isSelected = false
        let deselectedDay = Selection()
        deselectedDay.date = days[indexPath.row]
        delegate?.dayCollectionCellDeselected(deselectedDay: deselectedDay)
    }
    
    func updateMonthLabels() {
        let monthFormatter = DateFormatter()
        monthFormatter.timeZone = TimeZone.current
        monthFormatter.dateFormat = "MMMM"
        var monthArray = [String]()
        for day in self.days {
            monthArray.append(monthFormatter.string(from: day))
        }
        let uniqueMonths = Array(Set(monthArray))
        lblMonth1.text = uniqueMonths[0]
        if uniqueMonths.count > 1 {
            lblMonth1ConCenter.isActive = false
            lblMonth1ConLeft.isActive = true
            lblMonth2.text = uniqueMonths[1]
            lblMonth2.isHidden = false
        } else {
            lblMonth1ConCenter.isActive = true
            lblMonth1ConLeft.isActive = false
            lblMonth2.isHidden = true
        }
        layoutIfNeeded()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionSize = self.collectionView.frame.size
        let cellSize = CGSize(width: (collectionSize.width-5) / 7, height: collectionSize.height-10)
        layout.invalidateLayout()
        return cellSize
    }
}

