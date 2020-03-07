//
//  EyeSwitchView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 12/3/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift

class EyeSwitchView: UIView {

    // MARK: - Variables public
    var isActive: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Variables private
    private var eyeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_eye")
        return imageView
    }()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Private methods
    private func setup() {
        //general
        layer.borderWidth = 0.5
        layer.borderColor = App.Color.main.rawValue.cgColor
        layer.masksToBounds = true
        
        //image view
        addSubview(eyeImage)
        eyeImage.alignExpandToSuperview()
        
        //events
        subscribeToEvents()
    }
    
    private func subscribeToEvents() {
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self.isActive = !self.isActive
        }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        if isActive {
            eyeImage.isHidden = false
        } else {
            eyeImage.isHidden = true
        }
    }

}
