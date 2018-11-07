//
//  FirstScreenBuilder.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 07/11/2018.
//  Copyright (c) 2018 Roger Prats. All rights reserved.
//
//

import UIKit

class FirstScreenBuilder {
    
    static func build() -> UIViewController {
        
        let viewController = FirstScreenViewController(nibName:String(describing: FirstScreenViewController.self), bundle: nil)
        let presenter = FirstScreenPresenter()
        let interactor = FirstScreenInteractor()
        let wireframe = FirstScreenWireframe()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        wireframe.viewController = viewController
        
        _ = viewController.view //force loading the view to load the outlets
        return viewController
    }
}
