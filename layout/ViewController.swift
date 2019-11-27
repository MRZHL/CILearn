//
//  ViewController.swift
//  layout
//
//  Created by Netban on 2019/11/14.
//  Copyright © 2019 scn. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    var subView:UIView!
    var tableView:UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 给SafeArea 扩容
         additionalSafeAreaInsets = UIEdgeInsets(top: 44, left: 10, bottom: 0, right: 10)
        
        /// 用代码布局默认采用的 Auto resizing
        /// 用StoryBoard 和 Xib 默认使用了 AutoLayout 的适配方式
//        subView = UIView()
//        subView.translatesAutoresizingMaskIntoConstraints = false
//        subView.backgroundColor = .gray
//        view.addSubview(subView)
//        NSLayoutConstraint.activate([
//            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
        
        
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.backgroundColor = UIColor.gray
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        
        
        
        

//        print(subView.description)
        
        firstly {
            longTime(5)
        }.done { (value) in
            print(value)
        }
        
        
       
       
      
        
        
        
        
        longTime(5).then {
            self.longTime($0)
        }.done {
            print("value == \($0)")
        }
        
     
        
        // tap
        firstly {
            after(seconds: 5)
        }.then {
            self.longTime(5)
        }.tap({ (result) in
            print(result)
        }).done { (value) in
            print("valuesss == \(value)")
        }
        
        // when 可以并行
        
        firstly {
            after(seconds: 5)
        }.then {
            when(fulfilled: [self.longTime(5),self.longTime(7)])
        }.done { (array) in
            print(array)
        }
        
        
        
        firstly {
            after(seconds: 5)
        }.done { (_) in
            
        }
        
    


    }
    
//    override func viewDidLayoutSubviews() {
//        print(view.safeAreaInsets)
//        print("view \(view.layoutMargins)")
//        print("subView \(subView.layoutMargins)")
//    }

    
    func longTime(_ value:Int) -> Promise<Int> {
        return Promise<Int> { seal in
            if value > 10{
                seal.reject(DataError.tooLarge)
            }else{
                seal.fulfill(value)
            }
        }
    }
    
    
    func haha(value:Int)->Promise<Promise<Int>>{
        return Promise<Promise<Int>>{
            sink in
            if(value > 5){
                sink.fulfill(Promise{seal in
                    if value > 10{
                        seal.fulfill(value)
                    }else{
                        seal.reject(DataError.NoData)
                    }
                })
            }else{
                sink.reject(DataError.tooLarge)
            }
        }
    }

}



extension ViewController:UITableViewDelegate{
    
}

extension ViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "第 -> \(indexPath.row)"
        return cell!
    }
}


enum DataError:Error {
    case NoData
    case tooLarge
}
