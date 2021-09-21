//
//  MenuView.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import UIKit

class MenuView: UIView {
    
    private var tableView: UITableView!
    private var menuView: UIView!
    private var fadeView: UIView!
    private var translationX = CGFloat()
    
    var data = ["Swift", "Dart", "Java", "Kotlin", "C++"]
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.backgroundColor = .none
        
        fadeView = UIView(frame: CGRect(x: self.frame.width / 3 * 2, y: self.frame.minY,
                                        width: self.frame.width / 3 , height: self.frame.height))
        menuView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY,
                                        width: self.frame.width - self.fadeView.frame.width, height: self.frame.height))
        
        fadeView.backgroundColor = .black
        fadeView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide(_:)))
        fadeView.addGestureRecognizer(tap)
        
        self.addSubview(menuView)
        self.addSubview(fadeView)
        
        self.frame.origin.x -= self.frame.maxX
        
        tableView = UITableView(frame: menuView.bounds)
        tableView.separatorStyle = .none
        menuView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(menuCell.self, forCellReuseIdentifier: menuCell.identifier)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    func show() {
        self.parentViewController?.navigationController?.isNavigationBarHidden = true
        
        UIView.animate(withDuration: 0.7) {
            self.frame.origin.x = 0
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.2) {
                fadeView.alpha = 0.5
            }
        }
        
    }
    
    @objc func hide(_ sender: UITapGestureRecognizer? = nil) {
        self.fadeView.alpha = 0
        
        UIView.animate(withDuration: 0.7) {
            self.frame.origin.x -= self.frame.maxX
            self.parentViewController?.navigationController?.isNavigationBarHidden = false
        }
    }
    
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCell.identifier, for: indexPath) as! menuCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
        let alert = UIAlertController(title: "SocioSoftware", message: data[indexPath.row], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        parentViewController?.present(alert, animated: false)
        
    }
    
}
