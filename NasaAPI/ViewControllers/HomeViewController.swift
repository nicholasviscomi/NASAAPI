//
//  ViewController.swift
//  NasaAPI
//
//  Created by Nick Viscomi on 9/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate let tableView: UITableView = {
        let field = UITableView()
        field.register(TableViewCollectionCell.self, forCellReuseIdentifier: Constants.homeCellIdentifier)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.separatorStyle = .none
        return field
    }()
    
    var data = [[APOD]]()
    let APICalls = APIMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        constrainViews()
        conform()
        styleUI()
        
        APICalls.getAPOD(date: "2020-9-25") { [self] (apod) in
            guard let apod = apod else { return }
            
            data.append([apod])
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
       
    }
    
    fileprivate func addViews() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
    }
    
    fileprivate func styleUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "NASA API's"

    }
    
    fileprivate func conform() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func constrainViews() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension HomeViewController: DetailViewDelegate {
    
    func cellWasTapped(cell: CollectionViewCell, location: CGPoint) {
        let cellCopy = cell
        let vc = CellLongPressViewController(cell: cellCopy, location: location)
        vc.title = ""
        vc.modalPresentationStyle = .overCurrentContext
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: false, completion: nil)
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeCellIdentifier, for: indexPath) as! TableViewCollectionCell
        cell.configure(with: data[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

