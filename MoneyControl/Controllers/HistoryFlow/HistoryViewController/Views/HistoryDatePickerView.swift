//
//  HistoryDatePickerView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

class HistoryDatePickerView: UIView {
    
    // MARK: - UI
    
    private var closeButton: UIButton!
    private var okButton: UIButton!
    private var pickerView: UIPickerView!
    
    // MARK: - Variables private
    
    private var _backClosure: EmptyClosure?
    private var _closeClosure: EmptyClosure?
    private var _chooseClosure: TypeClosure<Sort>?
    
    // MARK: - Variables public
    
    var selectedSort: Sort? {
        didSet {
            guard let sort = selectedSort else { return }
            
            if let caseIndex = Sort.allCases.index(of: sort.stringValue) {
                pickerView.selectRow(caseIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("HistoryDatePickerView")
    }
    
    // MARK: - Public methods
    
    func onCloseTap(completion: @escaping EmptyClosure) {
        _closeClosure = completion
    }
    
    func onChoose(completion: @escaping TypeClosure<Sort>) {
        _chooseClosure = completion
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        backgroundColor = .mainBackground
        
        closeButton = UIButton(type: .custom).then { closeButton in
            
            closeButton.setImage(UIImage(named: "ic_close"), for: .normal)
            closeButton.tintColor = .controlTintDestructive
            closeButton.addTarget(self, action: #selector(closeBtnEvent), for: .touchUpInside)
            
            addSubview(closeButton)
            closeButton.snp.makeConstraints {
                $0.height.width.equalTo(25)
                $0.right.top.equalToSuperview().inset(8)
            }
        }
        
        pickerView = UIPickerView().then { pickerView in
            
            pickerView.dataSource = self
            pickerView.delegate = self
            
            addSubview(pickerView)
            pickerView.snp.makeConstraints {
                $0.top.equalTo(closeButton.snp.bottom).offset(8)
                $0.left.right.equalToSuperview().inset(8)
            }
        }
        
        okButton = UIButton(type: .custom).then { okButton in
            
            okButton.setTitle("CHOOSE", for: .normal)
            okButton.titleLabel?.font = App.Font.main(size: 15, type: .bold).rawValue
            okButton.backgroundColor = UIColor.controlTintGreen.withAlphaComponent(0.8)
            okButton.addTarget(self, action: #selector(chooseBtnEvent), for: .touchUpInside)
            
            addSubview(okButton)
            okButton.snp.makeConstraints {
                $0.top.equalTo(pickerView.snp.bottom).offset(8)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(45)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Private methods
    
    @objc private func closeBtnEvent() {
        _closeClosure?()
    }
    
    @objc private func chooseBtnEvent() {
        _chooseClosure?(Sort.allValues[pickerView.selectedRow(inComponent: 0)])
    }
}

extension HistoryDatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Sort.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Sort.allCases[row]
    }
    
}
