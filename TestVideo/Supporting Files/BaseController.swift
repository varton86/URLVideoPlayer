//
//  BaseController.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 22/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

class BaseController<T: UIView>: UIViewController {
    let root = T()

    override func loadView() {
        view = root
    }
}
