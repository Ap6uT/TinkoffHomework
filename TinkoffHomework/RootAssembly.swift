//
//  RootAssembly.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 11.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
