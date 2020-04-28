//
//  ChooseCategoryViewViewModel.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 4/20/19.
//  Copyright © 2019 PxToday. All rights reserved.
//

import Foundation

protocol ChooseCategoryViewModelDelegate: class {
    func didFetchCategories()
}

class ChooseCategoryViewModel {
    
    // MARK: - Variables public
    
    let selectedCategory: CategoryViewModel?
    var categories: [CategoryViewModel] = []
    var selectedType: Transaction.TransactionType?
    
    weak var delegate: ChooseCategoryViewModelDelegate?
    
    // MARK: - Initializers
    init(category: CategoryViewModel?, selectedType: Transaction.TransactionType?) {
        self.selectedCategory = category
        self.selectedType = selectedType
    }
    
    // MARK: - Public methods
    
    func loadData() {
        
        let type: Transaction.TransactionType = selectedSegmentType() == .revenues ? .incoming : .outcoming
        
        //categories
        loadCategories(type: type)
    }
    
    func selectAndFetch(for segment: Segment) {
        selectedType = segment == .revenues ? .incoming : .outcoming
        loadCategories(type: selectedType!)
    }
    
    func loadCategories(type: Transaction.TransactionType) {
        categories = CategoryService.instance.fetchSavedCategories(type: type)
        delegate?.didFetchCategories()
    }
    
    func category(at indexPath: IndexPath) -> CategoryViewModel {
        categories[indexPath.row]
    }
    
    func isSelected(for indexPath: IndexPath) -> Bool {
        selectedCategory == categories[indexPath.row]
    }
    
    func selectedSegmentType() -> Segment {
        if let selectedType = selectedType {
            return selectedType == .incoming ? Segment.revenues : Segment.spendings
        } else {
            return Segment.spendings
        }
    }
}

extension ChooseCategoryViewModel {
    
    enum Segment: String, Localizable, CaseIterable {
        
        case spendings = "Spendings"
        case revenues = "Revenues"

        static let allCasesLocalized = Self.allCases.map { $0.localized }

        var index: Int {
            switch self {
            case .spendings: return 0
            case .revenues: return 1
            }
        }

        init(index: Int) {
            switch index {
            case 0: self = .spendings
            case 1: self = .revenues
            default: fatalError("Cannot instantiate Segment from index #\(index)")
            }
        }
    }
}

