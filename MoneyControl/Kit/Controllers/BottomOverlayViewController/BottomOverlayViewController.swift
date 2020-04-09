//
//  BottomOverlayViewController.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 09.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift

class BottomOverlayViewController: UIViewController {

    // MARK: - Variables private
    
    private var contentViewBottomConstraint: Constraint!
    private var contentView: UIView!
    private var tappableView:UIView!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("BottomOverlayViewController")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView(show: true)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // views
        
        contentView = UIView().then { contentView in
            view.addSubview(contentView)
            
            contentView.backgroundColor = .white
            contentView.applyCornerRadius(20, topLeft: true, topRight: true, bottomRight: false, bottomLeft: false)
        }
        
        tappableView = UIView().then { tappableView in
            view.addSubview(tappableView)
            
            tappableView.rx.tapGesture().when(.recognized).subscribe(onNext: { [unowned self] _ in
                self.closeController()
            }).disposed(by: disposeBag)
            
            tappableView.snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.bottom.equalTo(contentView.snp.top)
            }
        }
        
        updateConstraintsOfContentView(-200)
    }
    
    private func updateConstraintsOfContentView(_ bottomPadding: CGFloat) {
        guard contentView.superview != nil else { return }
        
        contentView.snp.makeConstraints {
            self.contentViewBottomConstraint = $0.bottom.equalTo(view.snp.bottom).inset(bottomPadding).constraint
            $0.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    private func contentView(show: Bool, completion: EmptyClosure? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.contentViewBottomConstraint.update(offset: show ? 0 : 200)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }, completion: { (_) in
                completion?()
            })
        }
    }
    
    func closeController() {
        contentView(show: false) {
            Router.instance.goBack()
        }
    }
    
}
