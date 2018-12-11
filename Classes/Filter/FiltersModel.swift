//
//  FiltersModel.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/12/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import Foundation

//protocol Filter {
//    var options: [String] { get }
//    var selectedOption: Int { get set }
//    var name: String { get }
//}

enum Filters: Int, CaseIterable {
    case category
    case city
    case difficulty
}

class Filter {
    var options: [String] = []
    var selectedOption: Int = 0
    var name: String = ""
    
    convenience init(options: [String], name: String) {
        self.init()
        self.options = options
        self.name = name
    }
    
    func getFilter() -> String? {
        if selectedOption == 0 { return nil }
        return options[selectedOption]
    }
}

class FilterManager {
    let difficulty = Filter(options: ["Any", "Easy", "Medium", "Hard"], name: "Difficulty")
    let category = Filter(options: ["Any","Adventure", "Investigation"], name: "Category")
    let city = Filter(options: ["Any", "Barberà del Vallès", "Sabadell"], name: "City")
    
    func resetFilters() {
        city.selectedOption = 0
        category.selectedOption = 0
        difficulty.selectedOption = 0
    }
    
    func updateSelectedOption(_ option: Int, forFilter index: Int) {
        guard let filters = Filters(rawValue: index) else { return }
        
        switch filters {
        case .category:
            category.selectedOption = option
        case .city:
            city.selectedOption = option
        case .difficulty:
            difficulty.selectedOption = option
        }
    }
    
    func getName(forFilter index: Int) -> String? {
        guard let filters = Filters(rawValue: index) else { return nil }
        
        switch filters {
        case .category:
            return category.name
        case .city:
            return city.name
        case .difficulty:
            return difficulty.name
        }
    }
    
    func getSelectedOption(forFilter index: Int) -> String? {
        guard let filters = Filters(rawValue: index) else { return nil }
        
        switch filters {
        case .category:
            return category.options[category.selectedOption]
        case .city:
            return city.options[city.selectedOption]
        case .difficulty:
            return difficulty.options[difficulty.selectedOption]
        }
    }
    
    func getFilter(_ index: Int) -> Filter? {
        guard let filters = Filters(rawValue: index) else { return nil }
        
        switch filters {
        case .category:
            return category
        case .city:
            return city
        case .difficulty:
            return difficulty
        }
    }
}
