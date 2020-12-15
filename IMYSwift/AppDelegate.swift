//
//  AppDelegate.swift
//  IMYSwift
//
//  Created by suzhiqiu on 2019/6/2.
//  Copyright © 2019 suzhiqiu. All rights reserved.
//


//https://www.jianshu.com/p/6004b9b2c7e7

import UIKit

/*
  分类
 */
 extension UIView {
     public var x: CGFloat {
         get {
            return self.frame.origin.x;
         }
         set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
         }
     }
 }
/*
 协议
 */
protocol UIViewProtocol : class {
    func read() -> String
}

class MyClass: UIViewProtocol {
    func read() -> String {
        return "read"
    }
}

/*
block
*/
typealias ClickBlock = (Int)->Void

class YouVC : UIViewController {
    /*
       声明代理
       */
     // weak var delegate: UIViewProtocol?
    weak var delegate: UIViewProtocol?
    
    var clickBlock:ClickBlock?
    
    func read() {
        if let txt = self.delegate?.read() { //必须得解码出来
            var ss:String = txt
            print(ss)
        } else  {
            print("为空了")
        }
        
        if let clickIndexBock = clickBlock {
            clickIndexBock(5)
        }
        /*
         Swift 通知
        */
        NotificationCenter.default.post(name: NSNotification.Name("Notify"), object: nil, userInfo: nil)
    }
    
}
/*
kvo
*/

/*下标*/
class DayWeaks {
    private  var days = ["OneDay","TwoDay","ThreeDay"]
    
    subscript(index:Int) -> String {
        get {
            return days[index]
        }
        set (newValue) {
            self.days[index] = newValue
        }
    }
    
}







@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UIViewProtocol{

    var window: UIWindow?

    func read() -> String {
        return "继承协议";
    }
    
//    func testFunc(param1:String,param2:Int) -> Bool {
//    func testFunc(lablel param1:String,param2:Int) -> Bool {
    func testFunc(_ param1:String,param2:Int) -> Bool {
        
        print("param1:\(param1),param2:\(param2)")
         return true
    }
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //1.集合声明与遍历
        var array:[Int] = [1,2,3,4]
        
        for (index,value) in array.enumerated() {
            print(index,value);
            print("");
        }
        let someDic:[Int:String] = [1:"s",2:"p"]
        for (key,value) in someDic {
            print("key:\(key) value:\(value) ")
            print("")
        }
        print("input param value is : \(someDic[1])")
        
        //2.字符串的操作
        var test:String  = "123456";
        test.insert("7", at: test.endIndex);
        test.append("100")
        test.insert("9", at: test.index(test.startIndex, offsetBy: 5));
        print(test);
        
        //3.条件语句 guard else
        guard array[0]==1 else {
            print("条件必须为真")
            return false;
        }
        //4.switch与枚举
        
        
        //5.函数
//        self.testFunc(param1: "woailuo", param2: 123)
//        self.testFunc(lablel: "woailuo", param2: 123)
        self.testFunc("woailuo", param2: 123)
        
        //6.闭包
        let names = ["bb","ss"]
        //(String, String) -> Bool
        let reversed0 = names.sorted(by: backward)
        
        let reversed1  = names.sorted(by:{ (s1:String, s2:String) -> Bool in
                        print(s1)
                        print(s2)
                            return s1 > s2
                          })
        let reversed2  = names.sorted(by:{ $0>$1 })
  
        
        print("reversed0:\(reversed0)")
        print("reversed1:\(reversed1)")
        print("reversed2:\(reversed2)")
  
        
        let sumFunc = { (a :Int ,b :Int) -> Int  in
                         return  a+b
                      }
        
        print("value is \(sumFunc(4,5)) ")
        
        //6.1尾随闭包
        /*
         将一个很长的闭包表达式作为最后一个参数传递给函数
         函数和闭包都是引用类型
         **/
        let reversed3  = names.sorted(){ $0>$1 }
        let reversed4  = names.sorted{ $0>$1 }
        print("reversed3:\(reversed3)")
        print("reversed4:\(reversed4)")
        //6.2自动闭包
        /*
         自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式
         */
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        print("customersInLine1:\(customersInLine.count)")
        let autoClose = { customersInLine.remove(at: 0) };
        print("customersInLine2:\(customersInLine.count)")
        let ss:String  = autoClose();
        print("customersInLine3:\(customersInLine.count) ,ss:\(ss)")
        
        //6.3逃逸闭包
        /*
         当一个闭包作为参数传到一个函数中，在函数返回之后才被执行。参数名之前标注 @escaping
         **/
        // customersInLine i= ["Barry", "Daniella"]
        var customerProviders: [() -> String] = []
        func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
            customerProviders.append(customerProvider)
        }
        collectCustomerProviders(customersInLine.remove(at: 0))
        collectCustomerProviders(customersInLine.remove(at: 0))

        print("Collected \(customerProviders.count) closures.")
        // 打印“Collected 2 closures.”
        for customerProvider in customerProviders {
            print("Now serving \(customerProvider())!")
        }
        
        
        
        
        //7.通知
       NotificationCenter.default.addObserver(self, selector: #selector(notifyMethod), name: NSNotification.Name("Notify"), object: nil)
        
     
       
     
    
        
        //下标
//        let dayWeaks = DayWeaks()
//        print("value is:\(dayWeaks[1])")
//
//        // var let
//        var myString:String? = "myString"
//        let myLetStr = myString;
//        print("value is:\(myString) let Str:\(myLetStr)")
//
//
//        var btn1: UIButton!
//        //btn1 = UIButton(type: .custom);
//        btn1.frame = CGRect.init(x: 10, y: 10, width: 10, height: 120);//报错
//
//        var btn2: UIButton?
//        btn2?.frame = CGRect.init(x: 10, y: 10, width: 10, height: 120);//没有报错，这里不执行  btn1?这个问号必须加上，不然编译之前就报错了
//
//        print("value is:")
        //as?  as! 向下类型转换
        //student as ? Man
        
        //any  AnyObject
        // id == Any可以表示任何类型，包括方法类型（function types
        // NSObject == AnyObject 可以代表任何class类型的实例
        

        
        
//Test 分类
//        var view:UIView = UIView()
//        view.x = 100
//        print(view)
        //Test 协议
        var  my:YouVC =  YouVC()
        my.delegate = self
       
    
        my.clickBlock  = {
            (param:Int)->Void in  // in
            print("input param value is : \(param)")
        }
        print(my.read());
        //==

        //通知
        //var anyArr:[Any] = [Any]()  // Class 类型 AnyObject  "1"  结构体啥的 用Any
        // AnyObject
        
        
        var cfstr: CFString = "Why does Swift require double casting" as CFString
        var nsstr: NSString = cfstr as NSString
    
        print("cfstr:\(cfstr) nsstr:\(nsstr)" )
        
//        self.data = 1;
//
//        print("data:\(data)")
        
      if let convertedRank = Rank1(rawValue: 3) {
         let threeDescription = convertedRank.simpleDescription()
         print("threeDescription:\(threeDescription)")
         print("")
      }
        
    //
    self.test()
        
        
        
    //
        return true
    }
    
    open class ModelA {
        var name:NSString = "我爱罗";
    }
    
 
    public func test() {
        let student:ModelA = ModelA()
        
        var arrayStudent:[ModelA] = [ModelA] ()
        arrayStudent.append(student);
        
        var arrayStudent2:[ModelA] = arrayStudent
        
        print("")
    }
    
    
    
//     public var data: Int? {
//        set {
//           data = newValue
//        }
//        get  {
//         print("data")
//        return 0
//        }
//    }
    

enum Rank1: Int {
     case ace = 1
     case two, three, four, five, six, seven, eight, nine, ten
     case jack, queen, king

     func simpleDescription() -> String {
         switch self {
         case .ace:
             return "ace"
         case .jack:
             return "jack"
         case .queen:
             return "queen"
         case .three:
             return "three"
         default:
             return String(self.rawValue)
         }
     }
 }
    func doWork(block:()->()) {
        print("header")
        block()
        print("footer")
    }
    func doWorkAsync(block: @escaping () -> ()) {
        DispatchQueue.main.async {
            block()
        }
    }

    
    
    
    @objc func notifyMethod() {
        print("notifyMethod")
    }
    
    /*
    GCD
    */
    func gcd() {
        DispatchQueue.main.async {
            print("main",Thread.current)
        }
        
        let queue = DispatchQueue(label: "queque", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
        queue.async {
             print("queue" , Thread.current)
        }
    }
    
    /*
     声明数组
     */
    var exampleany = [Any]()
    
    /*
     声明代理
     */
    weak var delegate: UIViewProtocol?
  
    
    /*
     1.语法过渡
      Swift                                           OC
     let:常量
     var:变量 不会覆给初始值
     ?和！
     
     float Double                                     CGFloat
     String:字符串  String(i)类型转换                    是NSString
     数组声明 ["数组变量1","数组变量2"]                   @[@"",@""]
     字典声明 ["key1":"value1","key2":"value2"]        @{@"key1":@"value1","key2":"value2"]}
     打印 print  \(插入变量)                            NSlog
     */

    
    func func2(str:String) -> String {
        return  "fun2->"+str
    }
    
    func func1(funx:(String)->String) -> String {//函数作为参数
        return "fun1调用:"+funx("value");//函数内部传参
    }
    func doLog(str:String) -> String {
        
        let numInstance:Double=5;
        let strInstance="cde";
        var str1="abc";
        str1=str1+strInstance+String(numInstance);
        
        var array = ["数组变量1","数组变量2"];
        var dic=["key1":"value1","key2":"value2"];
        print("instance:\(numInstance) array:\(array[1]),dic:\(dic["key1"]) ");
        
        
        //?和!
        var str:String? = "12"//可能为nil
        //str = nil;
        if (str != nil){
            str! = "123";  //赋值时候类型是确定的  同时str不为nil
        }
        //any 和 anyObject
        var objects = [Any]()
        
        objects.append(3)
        objects.append(3.141592653)
        objects.append("圆周率")
        
        for item in objects {
            switch item {
            case let someInt as Int:
                print("This is Int class \(someInt)")
            case let someDouble as Double:
                print("This is Double class \(someDouble)")
            default:
                print("This is String class \(item)")
            }
        }
        
        let swiftArr1 = ["a", "b", "c"]
        let swiftStr1 = "hello world"
        
        var array1 = [Any]()
        array1.append(swiftArr1)
        array1.append(swiftStr1)
        
        let swiftArr2 = ["a", "b", "c"]
        let swiftStr2 = "hello world"
        
        var array2 = [AnyObject]()
        array2.append(swiftArr2 as AnyObject)
        array2.append(swiftStr2 as AnyObject)
    
        // if let 对上面进行解包 并且得安全解包
        if  let name = str  as? String { //判断解包 后对象 是不是String 类型的
            print("解包 后对象 是String 类型的")
        }else {
            print("解包 后对象 不是String 类型的")
        }
        
        //闭包 函数参数
        var funStr = self.func1(funx: func2);
        var funStr2 = self.func1(funx: {//匿名
            (str:String)->String  in  //  in  来分割
            return "我爱罗"+str;
        });
        print ("fun result:\(funStr)") ;
        print ("no name fun result:\(funStr2)") ;
        //变量名 get set
        print("time:\(self.time)");
        self.time=50;
        print("timeCount:\(String(describing: self.timeCount))");
        //枚举类型  是一种类
        let rank = Rank.one
        print("Desc:"+rank.Desc())
        
        let rankString = RankString.one
        switch rankString {
        case .one:
            print("is RankOne")
        case .two:
            print("is RankTwo")
        default:
            print("no Rank")
        }
        let rankValue = RankValue.one(buy1: "100万", sale1: 10000);//可以传值
        switch rankValue {
        case .one(let buy1,let sale1)://let?
            print("buy:\(buy1) sale :\(sale1)")
        default:
            print("no RankValue")
        }
        //泛型
        print( "RankT:"+String( RankT<Int>.One(100).Desc() ))
   
        
    
        
        return str1;
    }
    
    //成员变量
    var timeCount : Double?
    var time: Double{
        set{
            timeCount = newValue/20
        }
        get{
            return 500
        }
    }
    //枚举类型
    enum Rank{
        case one
        case two
        func Desc() -> String {
            switch self {
            case .one:
                return "oneString"
            default:
                return "two"
            }
        }
        var  value:Int{
            switch self {
            case .one:
                return 100;
            default:
                return 200;
            }
        }
    }
    enum RankString :String {//其他类型
        case one="one"
        case two="two"
    }
    enum RankValue {
        case one(buy1:String,sale1:Int)
        case two(buy2:String,sale2:Int)
    }
    enum RankT<T> {
        case One(T)
        case Two(T)
        func Desc() -> T {
            switch self {
            case .One(let value):
                return value
            case .Two(let value):
                return value
            }
        }
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

