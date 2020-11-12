//
//  PresentationAssembly.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 09.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func contactsViewController() -> ContactsViewController
    func profileViewController() -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func dialogViewController() -> DialogViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ContactsViewController
    
    func contactsViewController() -> ContactsViewController {
        let model = contactsModel()
        let contactsVC = ContactsViewController(model: model, presentationAssembly: self)
        //model.delegate = contactsVC
        return contactsVC
    }
    
    private func contactsModel() -> IContactsModel {
        return ContactsModel(themesService: serviceAssembly.themesService,
                             chatSave: serviceAssembly.channelsCacheService,
                             fetchedResult: serviceAssembly.fetchedResultService,
                             observe: serviceAssembly.observeCacheService,
                             chatLoad: serviceAssembly.channelsLoad)
    }
    
    // MARK: - DialogViewController
    
    func dialogViewController() -> DialogViewController {
        let model = dialogModel()
        let dialogVC = DialogViewController(model: model, presentationAssembly: self)
        //model.delegate = dialogVC
        return dialogVC
    }
    
    private func dialogModel() -> IDialogModel {
        return DialogModel(themesService: serviceAssembly.themesService,
                           chatSave: serviceAssembly.messagesCacheService,
                           fetchedResult: serviceAssembly.fetchedResultService,
                           chatLoad: serviceAssembly.messagesLoad)
    }
    
    // MARK: - ProfileViewController
    
    func profileViewController() -> ProfileViewController {
        let model = profileModel()
        let profileVC = ProfileViewController(model: model, presentationAssembly: self)
        //model.delegate = profileVC
        return profileVC
    }
    
    private func profileModel() -> IProfileModel {
        return ProfileModel(themesService: serviceAssembly.themesService,
                            saveUser: serviceAssembly.userSaveService)
    }
    
    // MARK: - ThemesViewController
    
    func themesViewController() -> ThemesViewController {
        let model = themesModel()
        let themesVC = ThemesViewController(model: model, presentationAssembly: self)
        model.delegate = themesVC
        return themesVC
    }
    
    private func themesModel() -> IThemesModel {
        return ThemesModel(themesService: serviceAssembly.themesService)
    }
}
