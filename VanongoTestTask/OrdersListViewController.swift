//
//  ViewController.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import UIKit

final class OrdersListViewController: UIViewController {
    let storage = NotesStorage()
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addTapped))
    }
    
    @objc
    private func addTapped() {
        shawDetails()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.ordersListIdentifier)
        tableView.frame = view.frame
        tableView.backgroundColor = .systemGray6
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    private func shawDetails(id: Int? = nil) {
        let noteId = id ?? storage.getNotesCount()
        self.navigationItem.backButtonTitle = "Back".localize()
        self.navigationController?.pushViewController(orderDetailsController(noteId), animated: false)
    }
    
    private func orderDetailsController(_ id: Int) -> UIViewController {
        let view = OrderDetailsViewController(storage: storage, id: id)
        return view
    }
}

extension OrdersListViewController: UITableViewDelegate, UITableViewDataSource {
    static let ordersListIdentifier = "OrdersListIdentifier"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storage.getNotesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.ordersListIdentifier,
                                                 for: indexPath)
        let order = "Order".localize() + " \(indexPath.row + 1)"
        cell.textLabel?.text = order
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shawDetails(id: indexPath.row)
    }
}
