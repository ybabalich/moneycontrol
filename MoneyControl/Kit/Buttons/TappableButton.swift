//
//  TappableButton.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 21.01.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import RxSwift

class TappableButton: UIButton {

    // MARK: - Variables private
    private let disposeBag = DisposeBag()
    
    // MARK: - Public methods
    func onTap(completion: @escaping EmptyClosure) {
        rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            completion()
        }).disposed(by: disposeBag)
    }

}
