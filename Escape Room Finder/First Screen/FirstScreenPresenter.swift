//
//  FirstScreenPresenter.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 07/11/2018.
//  Copyright (c) 2018 Roger Prats. All rights reserved.
//
//

import Foundation

protocol FirstScreenEventHandler: class {
    
    var viewModel: FirstScreenViewModel { get }
    
    func handleViewWillAppear()
    func handleViewWillDisappear()
}

protocol FirstScreenResponseHandler: class {
    
    // func somethingRequestWillStart()
    // func somethingRequestDidStart()
    // func somethingRequestWillFinish()
    // func somethingRequestDidFinish()
}

class FirstScreenPresenter: FirstScreenEventHandler, FirstScreenResponseHandler {
    
    //MARK: Relationships
    
    weak var viewController: FirstScreenViewUpdatesHandler?
    var interactor: FirstScreenRequestHandler!
    var wireframe: FirstScreenNavigationHandler!

    var viewModel = FirstScreenViewModel()
    
    //MARK: - EventHandler Protocol
    
    func handleViewWillAppear() {
    }
    
    func handleViewWillDisappear() {
    }
    
    //MARK: - ResponseHandler Protocol
    
    // func somethingRequestWillStart(){}
    // func somethingRequestDidStart(){}
    // func somethingRequestWillFinish(){}
    // func somethingRequestDidFinish(){}
}
