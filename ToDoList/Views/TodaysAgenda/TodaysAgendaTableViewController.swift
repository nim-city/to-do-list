//
//  TodaysAgendaTableViewController.swift
//  ToDoList
//
//  Created by Nimish Narang on 2023-02-19.
//

import UIKit

class TodaysAgendaViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var itemListDelegate: ItemListDelegate?
    
    var toDoItems: [ToDoItem] {
        itemListDelegate?.todaysAgenda ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ItemTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.reuseIdentifier)
    }
    
    
    func reloadData() {
        tableView.reloadData()
    }
}


// MARK: - Table view stuff


extension TodaysAgendaViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        TableViewFooterView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        UIConstants.tableViewFooterHeight
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        let toDoItem = toDoItems[indexPath.row]
        
        cell.itemName = toDoItem.name
        cell.setUpCell(numItems: toDoItems.count, position: indexPath.row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableViewCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: Localization.getStringForKey(.delete), handler: { [weak self] _, _, _ in
            guard let toDoItem = self?.toDoItems[indexPath.row] else { return }
            let _ = TodaysAgendaFunctions.instance.unselectItem(toDoItem)
            self?.reloadData()
        })
        deleteSwipeAction.image = UIImage(systemName: UIConstants.trashImage)
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteSwipeAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }
    
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableView.reloadData()
    }
    
}
