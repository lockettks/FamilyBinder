//
//  CalendarTableViewCell.swift
//  FamilyBinder
//
//  Created by Kimberly Mathieu on 11/26/17.
//  Copyright © 2017 kimMathieu. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var days = [Date]()
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var lblMonth1: UILabel!
    @IBOutlet weak var lblMonth2: UILabel!
    
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func updateMonthLabels() {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        var monthArray = [String]()
        for day in self.days {
            monthArray.append(monthFormatter.string(from: day))
        }
        let uniqueMonths = Array(Set(monthArray))
        lblMonth1.text = uniqueMonths[0]
        if uniqueMonths.count > 1 {
            lblMonth1.frame.origin.x = 35
            
            lblMonth2.text = uniqueMonths[1]
            lblMonth2.isHidden = false
        } else {
            
            lblMonth1.center.x = collectionView.center.x
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
        let cellSize = CGSize(width: collectionSize.width / 7, height: collectionSize.height)
        layout.invalidateLayout()
        return cellSize
    }

   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionViewCell selected \(indexPath)")
    }
    
    
}

