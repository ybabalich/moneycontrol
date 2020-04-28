//
//  DateSetView.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 15.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RxSwift

class DateSetView: UIView {

    // MARK: - UI
    
    private var titleLabel: UILabel!
    private var downImageView: UIImageView!
    
    private var oldFrame: CGRect = .zero
    private var _tapClosure: EmptyClosure?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if oldFrame != frame {
            applyFullyRounded(4)
            oldFrame = frame
        }
    }
    
    // MARK: - Public methods
    
    func apply(title: String) {
        titleLabel.text = title.uppercased()
    }
    
    func onTap(completion: @escaping EmptyClosure) {
        _tapClosure = completion
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        backgroundColor = UIColor.mainElementBackground.withAlphaComponent(0.3)
        
        titleLabel = UILabel().then { titleLabel in
            
            titleLabel.isUserInteractionEnabled = true
            titleLabel.textAlignment = .left
            titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(16)
                $0.centerX.equalToSuperview()
            }
        }
        
        downImageView = UIImageView().then { downImageView in

            downImageView.isUserInteractionEnabled = true
            downImageView.image = UIImage(named: "ic_down_arrow")
            downImageView.tintColor = .controlTintActive
            
            downImageView.snp.makeConstraints {
                $0.width.equalTo(10)
                $0.height.equalTo(9)
            }
        }
        
        let _ = UIStackView().then { stackView in
            stackView.distribution = .equalSpacing
            stackView.spacing = 12
            stackView.axis = .horizontal
            stackView.alignment = .center
            
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(downImageView)
            
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.left.right.equalToSuperview().inset(12)
            }
        }
        
        //events
        
        rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
            self._tapClosure?()
        }).disposed(by: disposeBag)
    }
}
