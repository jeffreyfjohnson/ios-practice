//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var hello = "Hello world"
let myHello = hello

let dictionary = [1992:"Jeff", 1995:"Pat", 1998:"Claire"]

dictionary[1996]

if let myConstant = dictionary[1998]{
    print("ok")
}
else{
    print("not ok")
}

let months: [String] = ["Jan", "Feb", "March", "April"]

for (year,string) in dictionary{
    print("\(string) was born in \(year)")
}

enum PieType: Int{
    case Apple = 0
    case Cherry
    case Pecan
}

let pieRaw: Int = PieType.Pecan.rawValue