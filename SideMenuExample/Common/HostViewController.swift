import UIKit

class HostViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    var navVC: UINavigationController?
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    
    // Child controllers
    lazy var infoVC = InfoViewController()
    lazy var appRatingVC = AppRatingViewController()
    
    private var menuState: MenuState = .closed
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        menuVC.view.frame = CGRect(
            x: -view.frame.size.width,
            y: 0,
            width: view.frame.size.width / 4,
            height: view.frame.size.height
        )
        
        addChildVCs()
    }
    
    private func addChildVCs() {
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
        
        // Add the dimming view on top of contentVC but below the menuVC
        dimmingView.frame = navVC.view.bounds
        navVC.view.addSubview(dimmingView) // Add dimming view to content's view
        
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
    }
}

extension HostViewController: MenuViewControllerDelegate {
    func dismissMenu() {
        toggleMenu()
    }
    
    
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu()
        
        switch menuItem {
        case .home:
            resetToHome()
        case .info:
//                let vc = InfoViewController()
//                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            
            addInfo()
        case .appRating:
            addAppRating()
        case .shareApp:
            break
        case .settings:
            break
        }
    }
    
    func resetToHome() {
        infoVC.view.removeFromSuperview()
        infoVC.didMove(toParent: nil)
        
        appRatingVC.view.removeFromSuperview()
        appRatingVC.didMove(toParent: nil)
        
        homeVC.title = "Home"
    }
    
    func addInfo() {
        // Fullscreen
//        addChild(infoVC)
//        view.addSubview(infoVC.view)
//        infoVC.view.frame = view.frame
//        infoVC.didMove(toParent: self)
        
        homeVC.addChild(infoVC)
        homeVC.view.addSubview(infoVC.view)
        infoVC.view.frame = view.frame
        infoVC.didMove(toParent: homeVC)
        homeVC.title = infoVC.title
    }
    
    func addAppRating() {
        homeVC.addChild(appRatingVC)
        homeVC.view.addSubview(appRatingVC.view)
        appRatingVC.view.frame = view.frame
        appRatingVC.didMove(toParent: homeVC)
        homeVC.title = appRatingVC.title
    }
}

extension HostViewController: HomeViewControllerDelegate {
    
    func didTapMenuButton() {
        toggleMenu()
    }
    
    func toggleMenu() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0) {
                self.menuVC.view.frame.origin.x = 0
                self.dimmingView.alpha = 1
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
            
        case .opened:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0) {
                self.menuVC.view.frame.origin.x = -self.menuVC.view.frame.size.width
                self.dimmingView.alpha = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
}

