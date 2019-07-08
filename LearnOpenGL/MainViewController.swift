//
//  ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/7.
//  

import UIKit

class MainViewController: UIViewController {

    typealias Lesson = (name: String, values: [String])

    private let lessons: [Lesson] = [
        ("Lesson 1", ["Colorful GLKit"]),
        ("Lesson 2", ["Draw A Triangle"])
    ]

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.view.addSubview(tableView)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return lessons.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons[section].values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")

        cell.textLabel?.text = lessons[indexPath.section].values[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return lessons[section].name
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = indexPath.section
        let row = indexPath.row

        var viewController: UIViewController?

        if section == 0 {
            if row == 0 {
                viewController = L1ViewController()
            }
        } else if section == 1 {
            if row == 0 {
                viewController = L2ViewController()
            }
        }

        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

private extension MainViewController {
    
}

