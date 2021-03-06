//
//  SyncSettingsViewModel.swift
//  TaskIt
//
//  Created by Kyle Dold on 22/04/2021.
//

import Foundation

class SyncSettingsViewModel: SyncSettingsViewModelProtocol {
    
    // MARK: - Properties
    
    var titleText = NSLocalizedString("settings.sync_settings.title", comment: "title")
    
    var iCloudSyncText = NSLocalizedString("settings.sync_settings.icloud.title", comment: "icloud sync title")
    var iCloudSyncDescription = NSLocalizedString("settings.sync_settings.icloud.description", comment: "icloud sync description")
    
    @Published var isICloudSyncEnabled = false
}
