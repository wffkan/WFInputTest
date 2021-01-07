//
//  WFInputView.swift
//  WFInputDemo_Example
//
//  Created by benny wang on 2021/1/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit


open class WFInputView: UIView {
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.layer.cornerRadius = 6
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return tf
    }()
    
    lazy var recommendListView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.layer.cornerRadius = 6
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        return tableView
    }()
    
    var dataArray: [String] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inputTextField)
        recommendListView.isHidden = true
        addSubview(recommendListView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.inputTextField.frame = self.bounds
        self.recommendListView.frame = CGRect(x: 0, y: self.inputTextField.frame.size.height+5, width: self.inputTextField.frame.size.width, height: 250)
    }
    
    @objc func textChanged(tf: UITextField) {
        //输入内容发生变化时，正常从网络请求推荐列表去匹配，这儿模拟本地数据
        let text = tf.text ?? ""
        dataArray.removeAll()
        for _ in 0...10 {
            dataArray.append("北京青云科技有限公司")
        }
        self.recommendListView.reloadData()
        self.recommendListView.isHidden = text.isEmpty
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WFInputView: UITableViewDataSource,UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
        //正则匹配输入的文字
        let originStr = dataArray[indexPath.row]
        let n_Attr = NSMutableAttributedString(string: originStr)
        if let regex = try? NSRegularExpression(pattern: self.inputTextField.text ?? "", options: .caseInsensitive) {
            regex.enumerateMatches(in: originStr, options: .reportProgress, range: NSRange(location: 0, length: originStr.count)) { (result, flags, stop) in
                n_Attr.addAttribute(.foregroundColor, value: UIColor.red, range: result?.range ?? NSRange(location: 0, length: 0))
            }
        }
        cell.textLabel?.attributedText = n_Attr
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
