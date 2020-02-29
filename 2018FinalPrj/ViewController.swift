//
//  ViewController.swift
//  2018FinalPrj
//
//  Created by gnsJhenJie on 2018/6/15.
//  Copyright © 2018年 gnsJhenJie.me. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    var ref: DatabaseReference!
    var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Keyboard dismiss
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    @IBAction func btnLogIn(_ sender: UIButton) {
        // email和密碼為必填欄位
        if self.emailTxtFld.text == "" || self.passwordTxtFld.text == "" {
            self.showMsg("請輸入email和密碼")
            return
        }else{
            var login=false
            Auth.auth().signIn(withEmail: self.emailTxtFld.text!, password: self.passwordTxtFld.text!) { (user, error) in
                //print("hello\n\(error)")
                // 登入失敗
                if error != nil {
                    login = false
                }else{
                    login = true
                }
                /*if login {
                 print("hi\n")
                 // 登入成功並顯示已登入
                 //self.showMsg("登入成功")
                 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                 let targetVC = storyBoard.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
                 
                 self.present(targetVC, animated: true, completion: nil)
                 
                 self.ref = Database.database().reference()
                 self.findUsername()
                 self.ref = Database.database().reference()
                 self.LoginSuccess()
                 }else{
                 print("nope\n")
                 // Show alert message and login again
                 let alertController = UIAlertController(title: "帳號或密碼錯誤", message:
                 "請再輸入一次", preferredStyle: UIAlertControllerStyle.alert)
                 alertController.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.default,handler: nil))
                 
                 self.present(alertController, animated: true, completion: nil)
                 return
                 }*/
                switch login{
                case true :
                    // open Buy lunch view
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let targetVC = storyBoard.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
                    do {
                        try self.ref = Database.database().reference()
                    } catch let signOutError as NSError {
                        print ("Error get ref: %@", signOutError)
                    }
                    //self.ref = Database.database().reference()
                    self.findUsername()
                    //username=txtfUsername.text!
                    self.present(targetVC, animated: true, completion: nil)
                //self.navigationController?.show(targetVC, sender: self)
                default :
                    // Show alert message and login again
                    let alertController = UIAlertController(title: "帳號或密碼錯誤", message:
                        "請再輸入一次", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "返回", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            return
        }
        
    }
    
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // ShowMessageWindow
    func showMsg(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func LoginSuccess (){
        
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "提示",
            message: "註冊成功,請重新登入",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let targetVC = storyBoard.instantiateViewController(withIdentifier: "Chat") as! ChatViewController
                self.present(targetVC, animated: true, completion: nil)
                print("按下確認後，閉包裡的動作")
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
    func findUsername() {

        let chatContents = ref.child("signUp").queryOrdered(byChild: "postDate").observe(.value) {
            (snapshot) in
            print("-----\n")
            // 逐一把firebase的記錄撈下
            self.userDefault.set("", forKey: "nickname")
            self.userDefault.synchronize()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    // 底下是單一筆的聊天記錄，逐一被抓到snap中
                    if let post = snap.value as? [String : AnyObject] {
                        // 把聊天記錄的架構拆開
                        let email = post["email"] as!   String
                        let nickname = post["nickname"] as! String
                        //let date = post["postDate"] as? String
                        // 如果email對就存nickname
                        if email == Auth.auth().currentUser?.email {
                            self.userDefault.set(nickname, forKey: "nickname")
                            self.userDefault.synchronize()
                        }
                    }
                }
            }
        }
    }
}

