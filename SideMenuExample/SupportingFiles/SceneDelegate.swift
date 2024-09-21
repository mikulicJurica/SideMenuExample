import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene: UIWindowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = HostViewController()
        window?.makeKeyAndVisible()
    }
}
