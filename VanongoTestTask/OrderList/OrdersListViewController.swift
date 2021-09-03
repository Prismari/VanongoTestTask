//
//  ViewController.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import UIKit

protocol OrderListView: AnyObject {
    func showDetailsWithModel(_ model: OrderDetailModel)
    func updateList()
}

final class OrdersListViewController: UIViewController {
    let model: OrderListModel
    
    private var tableView: UITableView
    
    init(model: OrderListModel) {
        self.model = model
        tableView = UITableView()

        super.init(nibName: nil, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.ordersListIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addTapped))
    }
    
    @objc
    private func addTapped() {
        model.userDidTapAddButton()
    }
    
    private func setupTableView() {
        tableView.frame = view.frame
        tableView.backgroundColor = .systemGray6
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
}

extension OrdersListViewController: UITableViewDelegate, UITableViewDataSource {
    static let ordersListIdentifier = "OrdersListIdentifier"

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cellsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.ordersListIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = model.cellTitle(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.userDidTapOnOrder(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension OrdersListViewController: OrderListView {
    func showDetailsWithModel(_ model: OrderDetailModel) {
        let viewController = OrderDetailsViewController(model: model)
        self.navigationItem.backButtonTitle = "Back".localize()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func updateList() {
        tableView.reloadData()
    }
}
