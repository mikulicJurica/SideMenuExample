import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
    func dismissMenu()
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case info = "Info"
        case appRating = "App Rating"
        case shareApp = "Share App"
        case settings = "Settings"
        
        var imageName: String {
            switch self {
            case .home:
                return "house"
            case .info:
                return "airplane"
            case .appRating:
                return "star"
            case .shareApp:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = nil
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }()
    
    private let backgroundColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(dismissButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = backgroundColor
    }

    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 50,
            width: view.bounds.size.width,
            height: view.bounds.size.height - 50
        )
        
        dismissButton.frame = CGRect(
            x: view.bounds.size.width - 50,
            y: view.safeAreaInsets.top,
            width: 50,
            height: 50
        )
    }
    
    @objc func didTapDismiss() {
        delegate?.dismissMenu()
    }

}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuOptions.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = backgroundColor
        cell.contentView.backgroundColor = backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}
