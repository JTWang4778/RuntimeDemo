//
//  SwiftViewController.swift
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/5/7.
//  Copyright © 2018年 JTWang. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {
    
    let ivar1 = 0  // 通过
    
    var asdf : Int {
     return 12
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.title = "swift"
        
        /*
            1，在swift中使用运行时的前提是， 继承自NSObject
            2， 对于自定义的类， ， 并且只能获取自己添加的， 不能获取父类的 属性和变量
            3，对于私有的变量， 一般是下划线开头的
         */
        getAllProperty()
//        getAllIvar()
//        getAllMethod()
        
        
//        changeValue()
    }
    
    func getAllProperty(){
        
        var count: UInt32 = 0
        let classss : AnyClass? = UINavigationController.classForCoder()
        
        let list = class_copyPropertyList(classss, &count)
        
        print("共有\(count)属性")
        
        for i in 0..<Int(count) {
            
            let pty : objc_property_t? = list?[i]
            
            let cName = property_getName(pty)
            
            let name = String(utf8String: cName!)
            
            print(name)
            
        }
        free(list)
    }
    
    func getAllIvar(){
        
        var count: UInt32 = 0
        let classss : AnyClass? = UINavigationController.classForCoder()
        
        let list = class_copyIvarList(classss, &count)
        
        print("共有\(count)变量")
        
        for i in 0..<Int(count) {
            
            if let pty = list?[i] {
                
                let ivarName = ivar_getName(pty)
                
                let name = String(utf8String: ivarName!)
                
                print(name)
            }
            
        }
        free(list)
    }
    
    func getAllMethod(){
        var count: UInt32 = 0
        let classss : AnyClass? = SwiftViewController.classForCoder()
        let methods = class_copyMethodList(classss, &count)
        print("共有\(count)方法")
        
        for i in 0..<Int(count) {
            
            if let method = methods?[i] {
                
                let methodName = method_getName(method)
                print(methodName?.description)
                
//                let name = String(utf8String: ivarName!)
                
//                print(name)
            }
            
        }
        free(methods)
        
    }
    
    
    func changeValue(){
        
        // _interactiveTransition
        if let navi = self.navigationController {
            if let value = navi.value(forKey: "_interactiveTransition") as? AnyObject {
                print(value.classForCoder)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
