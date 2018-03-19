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
    fileprivate let itemsPerRow: CGFloat = 7
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var lblMonth1: UILabel!
    @IBOutlet weak var lblMonth2: UILabel!
    @IBOutlet var lblMonth1ConLeft: NSLayoutConstraint!
    @IBOutlet var lblMonth1ConCenter: NSLayoutConstraint!
    weak var selectDayDelegate: SelectDayDelegate?
    
    func initWithModel(days: [Date]){
        self.days = days
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
        cell.isUserInteractionEnabled = days[indexPath.row].withoutTime() >= Date().withoutTime()

        return cell
    }
    
    func tableRowSelected(indexOfSelected: Int){
        let indexOfSelected = IndexPath(row: indexOfSelected, section: 0)
        collectionView.selectItem(at: indexOfSelected, animated: true, scrollPosition: [])
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
        selectDayDelegate?.dayCollectionCellSelected(selectedDay: newSelection)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarDayCollectionViewCell!
        cell?.isSelected = false
        let deselectedDay = Selection()
        deselectedDay.date = days[indexPath.row]
        selectDayDelegate?.dayCollectionCellDeselected(deselectedDay: deselectedDay)
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

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = self.collectionView.frame.size.width / itemsPerRow
        let heightPerItem = (self.collectionView.frame.size.height) / 2
        

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}

