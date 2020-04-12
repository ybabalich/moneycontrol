//
//  HistoryTitleView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

protocol LabeledView {
    func show(title: String?)
}

class HistoryTitleView: UIView, LabeledView {

    // MARK: - UI
    
    private var firstLabel: UILabel!
    private var secondLabel: UILabel!
    
    // MARK: - Class methods
    
    class func view() -> (LabeledView & UIView) {
        if #available(iOS 11, *) {
            return HistoryTitleView()
        } else {
            let label = UILabel()
            label.numberOfLines = 1
            label.textColor = .primaryText
            label.font = App.Font.main(size: 14, type: .bold).rawValue
            label.textAlignment = .right
            return label
        }
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func show(title: String?) {
        show(firstTitle: title, secondTitle: nil)
    }
    
    func show(firstTitle: String?, secondTitle: String?) {
        
        //titles
        
        if let firstTitle = firstTitle {
            firstLabel.text = firstTitle
        } else {
            firstLabel.isHidden = true
        }
        
        if let secondTitle = secondTitle {
            secondLabel.text = secondTitle
        } else {
            secondLabel.isHidden = true
        }
        
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        firstLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .primaryText
            $0.font = App.Font.main(size: 14, type: .bold).rawValue
            $0.textAlignment = .right
        }
        
        secondLabel = UILabel().then {
            
            $0.numberOfLines = 1
            $0.textColor = .primaryText
            $0.font = App.Font.main(size: 14, type: .bold).rawValue
            $0.textAlignment = .right
        }
        
        let _ = UIStackView().then { stackView in
            
            stackView.addArrangedSubview(firstLabel)
            stackView.addArrangedSubview(secondLabel)
            stackView.axis = .vertical
            stackView.spacing = 3
            stackView.alignment = .center
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
    }
    
}

extension UILabel: LabeledView {

    func show(title: String?) {
        text = title
        sizeToFit()
    }
}
