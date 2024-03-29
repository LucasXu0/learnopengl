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
        ("Lesson 2", ["Draw A Triangle By VBO", "Draw A Triangle By EBO", "Draw A Triangle By VAO"]),
        ("Lesson 3", ["Custom Base Effect"]),
        ("Lesson 4", ["Draw A Picture"]),
        ("Lesson 5", ["Transform"]),
        ("Lesson 6", ["Coordinate Systems"])
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

        if let viewController = self.viewController(for: indexPath) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

private extension MainViewController {
    private func viewController(for indexPath: IndexPath) -> UIViewController? {

        let section = indexPath.section
        let row = indexPath.row

        var viewController: UIViewController?

        if section == 0 {
            viewController = L1ViewController()
        } else if section == 1 {
            if row == 0 {
                viewController = L2_1ViewController()
            } else if row == 1 {
                viewController = L2_2ViewController()
            } else if row == 2 {
                viewController = L2_3ViewController()
            }
        } else if section == 2 {
            viewController = L3ViewController()
        } else if section == 3 {
            viewController = L4ViewController()
        } else if section == 4 {
            viewController = L5ViewController()
        } else if section == 5 {
            viewController = L6ViewController()
        }

        return viewController
    }
}

