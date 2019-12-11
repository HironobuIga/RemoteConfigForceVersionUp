//
//  ViewController.swift
//  RemoteConfigForceUpdate
//
//  Created by 伊賀裕展 on 2019/12/08.
//  Copyright © 2019 Iganin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    private var remoteConfigPropertyProvider: RemoteConfigPropertyProvider!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showForceAlertIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Function
}

// MARK: - Private Function
private extension ViewController {
    func setup() {
        remoteConfigPropertyProvider = RemoteConfigService.shared
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        showForceAlertIfNeeded()
    }
    
    func showForceAlertIfNeeded() {
        guard let forceAlertInformation = remoteConfigPropertyProvider.getForceAlertInformation() else { return }
        
        let currentVersion = AppUtility.currentVersion
        let criteriaVersion = forceAlertInformation.version
        if VersionUtility().isForceAlertRequired(
            currentVersion: currentVersion, criteriaVersion: criteriaVersion) {
            showForceAlert(information: forceAlertInformation)
        }
    }
    
    func showForceAlert(information: ForceAlertInformation) {
        let alertController = UIAlertController(
            title: information.title,
            message: information.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // okを押下後にAlertが非表示にならない用再度表示します
            self?.showForceAlert(information: information)
            if let url = information.url,
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
            
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
