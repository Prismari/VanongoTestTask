//
//  SceneDelegate.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootViewController = UINavigationController(rootViewController: rootViewController())
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func rootViewController() -> UIViewController {
        let storage = OrdersStorageImp(realm: realm())
        let model = OrderListModelImp(storage: storage)
        let viewController = OrdersListViewController(model: model)
        model.viewController = viewController
        return viewController
    }
    
    private func realm() -> Realm? {
        let realm: Realm?
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
            })
        
        Realm.Configuration.defaultConfiguration = config
        do {
            realm = try Realm()
        } catch {
            print("Failed by Realm initialisation")
            realm = nil
        }
        return realm
    }
}

