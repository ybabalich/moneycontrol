//
//  DayViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 10/1/18.
//  Copyright © 2018 PxToday. All rights reserved.
//

import RxSwift
import RxCocoa

class DayViewViewModel {
    
    let history = Variable<[Money]>([Circulation(value: 100, currency: .usd, type: .incoming, category: Category(title: "Category 1", image: UIImage()), entity: .card(name: "Mono")),
                                                  Circulation(value: 50, currency: .usd, type: .outcoming, category: Category(title: "Category 2", image: UIImage()), entity: .cash),
                                                  Circulation(value: 200, currency: .usd, type: .outcoming, category: Category(title: "Category 3", image: UIImage()), entity: .card(name: "PrivatBank"))])
    

}
