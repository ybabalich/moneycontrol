//
//  Coordinator.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 30.04.2020.
//  Copyright © 2020 PxToday. All rights reserved.
//

import UIKit

protocol CoordinatorDelegate: class {
    func coordinatorDidStart(_ coordinator: Coordinator)
    func coordinatorDidFinish(_ coordinator: Coordinator)
}

protocol CoordinatorProtocol {
    func start()
    func finish()
}

//

class Coordinator: NSObject, CoordinatorProtocol {

    weak var delegate: CoordinatorDelegate?

    var isPresented: Bool = false

    //
    
    func start() {
        isPresented = true
        delegate?.coordinatorDidStart(self)
    }
    
    func finish() {
        isPresented = false
        delegate?.coordinatorDidFinish(self)
    }
}

