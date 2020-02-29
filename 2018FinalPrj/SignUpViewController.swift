//
//  SignUpViewController.swift
//  2018FinalPrj
//
//  Created by gnsJhenJie on 2018/6/15.
//  Copyright © 2018年 gnsJhenJie.me. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Keyboard dismiss
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var ref: DatabaseReference!
    @IBOutlet weak var txtNickname: UITextField!
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func btnSignUp(_ sender: UIButton) {
        // email和密碼為必填欄位
        if self.txtAccount.text == "" || self.txtPassword.text == "" {
            self.showMsg("請輸入email和密碼")
            return
        } else if (self.txtNickname.text?.count)! >= 18 {
            self.showMsg("nickname過長")
            return
        }
        
        // 建立帳號
        Auth.auth().createUser(withEmail: self.txtAccount.text!, password: self.txtPassword.text!) { (user, error) in
            
            // 註冊失敗
            if error != nil {
                self.showMsg((error?.localizedDescription)!)
                return
            } else {
                Auth.auth().signIn(withEmail: self.txtAccount.text!, password: self.txtPassword.text!) { (user, error) in
                    
                    // 登入失敗
                    if error != nil {
                        self.showMsg((error?.localizedDescription)!)
                        return
                    }
                    
                }
                self.ref = Database.database().reference()
                // dictionary
                let signUp = [ "email": self.txtAccount.text! as Any,
                               "nickname": self.txtNickname.text! as Any,
                               "postDate": ServerValue.timestamp()] as [String : Any]
                self.ref.child("signUp").childByAutoId().setValue(signUp)
                // 註冊成功並顯示已登入
                self.SignUpSuccessMsg()
                //self.goBack()
            }
            

        }
    }
    

    // ShowMessageWindow
    func showMsg(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func SignUpSuccessMsg (){
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
                self.dismiss(animated: true, completion: nil)
                
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)

    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
