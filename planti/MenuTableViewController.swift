//
//  MenuTableViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {      
        NotificationCenter.default.post(name: NSNotification.Name("menuSelected"), object: nil, userInfo: ["menuOption": indexPath.row])
    }
}
