//
//  AppDelegate.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import BeautifulRequests
import DeallocationChecker
import Then
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    #if DEBUG
    DeallocationChecker.shared.setup(with: .alert) // There are other options than .alert too!
    #endif
    
    let window = UIWindow()
    window.makeKeyAndVisible()
    applyGlobalStyle()
    let storeViewController = MyStoreViewController(viewModel: MyStoreViewModel(service: StoreService(scheduler: RxScheduler())))
    let navStoreViewController = UINavigationController(rootViewController: storeViewController).then {
      $0.tabBarItem.title = L10n.storeTabItemTitle
      $0.tabBarItem.image = Asset.icArchive24pt.image
    }

    let scheduler = RxScheduler()
    let kakaoService = KakaoService(urlSession: URLSession.shared, scheduler: scheduler)
    let searchViewModel = MediaSearchViewModel(
      kakaoService,
      scheduler: scheduler
    )
    let tabBarController = UITabBarController()
    let mediaSearchViewController = MediaSearchViewController(viewModel: searchViewModel, scheduler: scheduler) {
      tabBarController.selectedIndex = 1
      storeViewController.reloadFavorites()
    }
    let navSearchViewController = UINavigationController(rootViewController: mediaSearchViewController)
    navSearchViewController.do {
      $0.tabBarItem.title = L10n.searchTabItemTitle
      $0.tabBarItem.image = Asset.icSearch24pt.image
    }
    tabBarController.viewControllers = [navSearchViewController, navStoreViewController]

    window.rootViewController = tabBarController

    self.window = window
    return true
  }
  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataManager.shared.saveContext()
  }
  private func applyGlobalStyle() {
    UITabBar.appearance().tintColor = ColorName.colorAccent
    UITextField.appearance().tintColor = ColorName.colorAccent
    UIRefreshControl.appearance().tintColor = ColorName.colorAccent
  }
}
