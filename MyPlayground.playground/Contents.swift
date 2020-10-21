//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import ApplicationFramework
import PromiseKit

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}

final class MyViewController : UIViewController {
    private var stackView: UIStackView!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .yellow

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
        stackView = UIStackView()
        stackView.frame =  CGRect(x: 100, y: 0, width: 200, height: 1000)
        stackView.backgroundColor = .darkGray
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        self.view = view
//        stackView.pinEdges(to: view)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func addImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
//        stackView.addSubview(imageView)
        stackView.addArrangedSubview(imageView)
        
        print(stackView.arrangedSubviews.count)
    }
    
}

let vc = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = vc

func getUserAvatar(id: Int) -> Promise<String> {
    return Promise { seal in
        guard let url = URL(string: "https://reqres.in/api/users/\(id)") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                    let user = json["data"] as? [String: Any]
                else {
                    return
                }
                seal.fulfill(user["avatar"] as? String ?? "")
            } catch let error {
                seal.reject(error)
            }
        }).resume()
    }
}

let waitAtLeast = after(seconds: 1)

let promises = [3].map {
    getUserAvatar(id: $0)
        .then { avatarStringUrl in
            URLSession.shared.dataTask(.promise, with: URL(string: avatarStringUrl)!)
        }.compactMap { data, urlResponse in
            UIImage(data: data)
        }
}

when(resolved: promises)
    .done { results in
        for result in results {
            print(result)
//            vc.addImage(image: result)
            if case .fulfilled(let image) = result {
                vc.addImage(image: image)
            }
        }
}

