//
//  FirstScreenInteractor.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 07/11/2018.
//  Copyright (c) 2018 Roger Prats. All rights reserved.
//
//

import Foundation

protocol FirstScreenRequestHandler: class {
    
    // func requestSomething()
}

class FirstScreenInteractor: FirstScreenRequestHandler {
    
    //MARK: Relationships
    
    weak var presenter: FirstScreenResponseHandler?
    
    //MARK: - RequestHandler Protocol
    
    //func requestSomething(){}
}
