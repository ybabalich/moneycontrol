//
//  CalendarCollectionViewCell.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/13/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import JTAppleCalendar

class CalendarCollectionViewCell: JTAppleCell {

    // MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    
    // MARK: - Variables public
    var isActive: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearUI()
    }
    
    // MARK: - Private methods
    private func updateUI() {
        backgroundColor = isActive ? App.Color.incoming.rawValue : UIColor.clear
    }
    
    private func clearUI() {
        isActive = false
    }

}
