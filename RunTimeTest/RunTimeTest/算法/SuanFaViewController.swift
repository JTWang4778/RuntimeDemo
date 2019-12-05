//
//  SuanFaViewController.swift
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/6/17.
//  Copyright © 2018年 JTWang. All rights reserved.
//

import UIKit



class SuanFaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "算法"
        
        // 打印2到100内的素数 （质数）
        printPrime_v2()
    }
    
    func printPrime_v1() {
        // 穷举法
        for i in 2...100{
            var temp = 0
            for j in 2...i {
                temp = j
                if i % j == 0 {
                    break
                }
            }
            if temp >= i {
                print(i)
            }
        }
    }
    
    func isPrime(n : Int) -> Bool{
//        let maxLemit = Int(sqrt(Double(n)))
//        for i in 2...maxLemit {
//            if n % i == 0 {
//                return false
//            }
//        }
        return true
    }
    
    func printPrime_v2() {
        for i in 2...100{
            if isPrime(n: i) {
                print(i)
            }
        }
    }

    // 快速排序
    func quicksort<T: Comparable>(_ a: [T]) -> [T] {
        guard a.count > 1 else { return a }
        
        let pivot = a[a.count/2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }
        
        return quicksort(less) + equal + quicksort(greater)
    }
    

}
