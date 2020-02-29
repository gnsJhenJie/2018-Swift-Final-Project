//
//  ChatViewController.swift
//  Chat
//
//  Created by TFAdmin on 2018/6/8.
//  Copyright © 2018年 TFAdmin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate  {
    var userDefault = UserDefaults.standard

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChat.count
    }
    @IBOutlet weak var labMyNickname: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvChatList.dequeueReusableCell(withIdentifier: "CellChat", for: indexPath) as? UITableViewCell
        // 把陣列中單一記錄的各個值填進cell的label中
        cell?.textLabel?.text = listOfChat[indexPath.row].content
        cell?.detailTextLabel?.text = listOfChat[indexPath.row].nickname
        return cell!
        
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y = keyboardFrame.minY - self.view.frame.height
                self.view.frame = frame
            })
        }
    }//test
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    var ref: DatabaseReference!
    var listOfChat = [Chat]()   //用來儲存聊天記錄的陣列
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBOutlet weak var tvChatList: UITableView!
    
    @IBOutlet weak var txtChatContent: UITextField!
    

    @IBAction func btnLogOut(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyBoard.instantiateViewController(withIdentifier: "Main") as! ViewController
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.ref = Database.database().reference()
        self.userDefault.set("", forKey: "nickname")
        self.userDefault.synchronize()
        self.present(targetVC, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSendChatContent(_ sender: UIButton) {
        let content = txtChatContent.text!
        var nickname = userDefault.string(forKey: "nickname")
        let postDate = ServerValue.timestamp()

        if nickname == nil {
            nickname = "Error_no_nickname"
        }

        
        // dictionary
        let chat = [ "content": content as Any,
                     "nickname": nickname as Any,
                     "postDate": postDate] as [String : Any]
        
        self.ref.child("chat").childByAutoId().setValue(chat)
        txtChatContent.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvChatList.dataSource = self
        tvChatList.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        // Log in Firebase with Anonymous account
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Cannot login: \(error)")
            } else {
                print("user \(user!)")
            }
        }
        ref = Database.database().reference()
        //labMyNickname.text = "Hello, " + userDefault.string(forKey: "nickname")!
        loadChatContent()   //去抓資料，放到陣列中
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        labMyNickname.text = "Hello, " + userDefault.string(forKey: "nickname")!
    }
    
    func loadChatContent() {
        let chatContents = ref.child("chat").queryOrdered(byChild: "postDate").observe(.value) {
            (snapshot) in
            // 逐一把firebase的記錄撈下來存到listOfChat
            self.listOfChat.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    // 底下是單一筆的聊天記錄，逐一被抓到snap中
                    if let post = snap.value as? [String : AnyObject] {
                        // 把聊天記錄的架構拆開
                        let nickname = post["nickname"] as? String
                        let text = post["content"] as? String
                        let date = post["postDate"] as? String
                        self.listOfChat.append(Chat(nickname: nickname!, content: text!, datePost: "\(date)"))
                    }
                }
                self.tvChatList.reloadData()
                let indexpath = IndexPath(row: self.listOfChat.count-1, section: 0)
                self.tvChatList.scrollToRow(at: indexpath, at: .bottom, animated: true)            }
        }
    }
}

