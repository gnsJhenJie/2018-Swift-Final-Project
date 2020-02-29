//
//  ResetPasswordViewController.swift
//  2018FinalPrj
//
//  Created by gnsJhenJie on 2018/6/28.
//  Copyright © 2018年 gnsJhenJie.me. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var txtAccount: UITextField!
    
    @IBAction func btnResetPassword(_ sender: UIButton) {
        let forgotPasswordAlert = UIAlertController(title: "重設密碼", message: "Enter email address", preferredStyle: .alert)
        /*forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }*/
        forgotPasswordAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { (action) in
            //let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: self.txtAccount.text!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "請求失敗", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "密碼重設信已送出", message: "請至email信箱收信！\n若收不到信，請檢查垃圾信箱！", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let targetVC = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController
                        self.present(targetVC, animated: true, completion: nil)
                    }))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
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
