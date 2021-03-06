//
//  IssuesViewController.swift
//  FiveCalls
//
//  Created by Ben Scheirman on 1/30/17.
//  Copyright © 2017 5calls. All rights reserved.
//

import UIKit

class IssuesViewController : UITableViewController {
    
    var issuesManager = IssuesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // edgesForExtendedLayout = []
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadIssues()
        
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(zipCodeChanged(_:)), name: .zipCodeChanged, object: nil)
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .none)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func zipCodeChanged(_ notif: Notification) {
        loadIssues()
    }
    
    private func loadIssues() {
        issuesManager.fetchIssues(completion: issuesLoaded)
    }

    private func issuesLoaded() {
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if segue.identifier == "issueSegue" {
            let dest = segue.destination as! IssueDetailViewController
            dest.issuesManager = issuesManager
            dest.issue = issuesManager.issues[indexPath.row]
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesManager.issues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell") as! IssueCell
        let issue = issuesManager.issues[indexPath.row]
        cell.titleLabel.text = issue.name
        return cell
    }
}
