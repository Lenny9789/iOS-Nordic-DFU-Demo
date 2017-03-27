//
//  ViewController.swift
//  Heart Rate
//
//  Created by 刘爽 on 2017/2/24.
//  Copyright © 2017年 智裳科技. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import SwiftMessages

//fileprivate let UUID_Service_HeartRate: String = "0000180d-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Notification_Heart_Rate: String = "00002a37-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Notification_Electrance: String = "0000fff3-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Service_T: String = "0000180d-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Data_TR: String = "0000fff5-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Service_StepCalculate: String = "6E400001-B5A3-F393-E0A9-E50E24DCCA0E"
//
//fileprivate let UUID_Notification_CurrentStepNumber: String = "6E400002-B5A3-F393-E0A9-E50E24DCCA0E"
//
//fileprivate let UUID_Notification_StepHistory: String = "6E400003-B5A3-F393-E0A9-E50E24DCCA0E"
//
//fileprivate let UUID_Notification_StepAllToday: String = "6E400004-B5A3-F393-E0A9-E50E24DCCA0E"
//
//fileprivate let UUID_Notification_StepStatus: String = "6E400005-B5A3-F393-E0A9-E50E24DCCA0E"
//
//fileprivate let UUID_Service_Battery: String = "0000180f-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Notification_Battery: String = "00002a19-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Service_Version: String = "0000180A-0000-1000-8000-00805f9b34fb"
//
//fileprivate let UUID_Notification_Version: String = "00002a27-0000-1000-8000-00805f9b34fb"

///DFU
fileprivate let UUID: String = "CB729CE7-F8F7-42AF-93C9-7495319F3DA0"

fileprivate let UUID_DFUServices: String = "00001530-1212-EFDE-1523-785FEABCD123"

fileprivate let UUID_DFUCharacteristics: String = "00001531-1212-efde-1523-785feabcd123"

class MainViewController: UIViewController,UIScrollViewDelegate ,CBCentralManagerDelegate,CBPeripheralDelegate,JBButtonDelegate,UITableViewDataSource,UITableViewDelegate {

    public class var shared: MainViewController {
        struct Static {
            static let instance: MainViewController = MainViewController()
            
        }
        
        return Static.instance
    }
    
    fileprivate var mainAdvDataArray: [Dictionary] = [Dictionary<String,Any>]()
    
    fileprivate var mainPeripheralMACAddres: String = ""
    
    fileprivate var viewContainsTableView: UIView = UIView()
    
    fileprivate var mainTableView: UITableView = UITableView()
    
    var isBluetoothOpened: Bool = false
    
    var isBluetoothConnected: Bool = false
    
    public var isDidDiscoveredPeripharal = false
    
    public var isConnectToNewPeripharal = false
    
    fileprivate var isCheckTheDFU = false
    
    var timeIntervalOfBluetoothSearchingOut: TimeInterval = Double(1)
    
    public var mainCentralManager = CBCentralManager()
    
    public var mainPeripheral: CBPeripheral?
    
    fileprivate var mainCharacteristicTX: CBCharacteristic?
//
//    fileprivate var mainCharacteristicRX: CBCharacteristic?
//    
//    fileprivate var mainService_T: CBService?
//
//    fileprivate var mainService_HeartRate: CBService?
//    
//    fileprivate var mainService_Step: CBService?
//    
//    fileprivate var mainService_Battery: CBService?
//    
//    fileprivate var mainService_Version: CBService?
//    
    public var mainArrayPeripheral = [CBPeripheral]()
//
//    fileprivate var mainArrayRSSI = [NSNumber]()
    
    fileprivate var mainTimer: Timer?
//    
//    var block_DidReceiveBatteryData: ((String) -> Void)  = { (str) in }
//    
//    var block_DidReceiveVersionData: ( (String) -> Void ) = { (str) in }
//    
//    var block_DidReceiveHeartRate: ( (String) -> Void ) = { (str) in }
//    
//    var block_DidRecieceCurrentStepNumber: ( (String) -> Void ) = { (str) in }
//    
//    var block_DidReceiceStepHistory: ( (String) -> Void ) = {  (str) in }
//    
//    var block_DidReceiveStepStatus: ( (String) -> Void ) = { (str) in }
//    
//    var block_DidReceiveStepAllDay: ( (String) -> Void ) = { (str) in }
//    
//    var block_DidReceiveHeartElectrance: ( (NSData) -> Void) = { (data) in }
//
//    var block_DidReceiveActiveTime: ( (String) -> Void ) = { (str) in }
    var block_DDDD: ( (_ manager:CBCentralManager, _ peripharal: CBPeripheral) -> Void) = { (manager,p) in }
    
    fileprivate var mainTimer2: Timer?
    
    fileprivate var button_DFU: JBButton = JBButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCentralManager.delegate = self
        
        self.view.backgroundColor = UIColor.white
//        self.view.addSubview(button_DFU)
//        button_DFU.whc_Center(0, y: 0).whc_Width(200).whc_Height(44)
//        button_DFU.setTitleFont(UIFont.systemFont(ofSize: 16))
//        button_DFU.setTitleText("连接蓝牙")
//        button_DFU.delegate  = self
//        button_DFU.backgroundColor = UIColor.init(red: 0, green: 200/255, blue: 50/255, alpha: 0.6)
//        button_DFU.titleColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainCentralManager.delegate = self
        startScan()
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
}



extension MainViewController {
    
    func didTapOnButton(_ sender: JBButton!) {
        startScan()
    }
}



extension MainViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mainArrayPeripheral.count > 0 {
            return mainArrayPeripheral.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as! SCTDiscoveredBLETableViewCell
        if cell !== SCTDiscoveredBLETableViewCell() {
            cell = SCTDiscoveredBLETableViewCell(style: .default, reuseIdentifier: ID)
            let peripheral: CBPeripheral = mainArrayPeripheral[indexPath.row]
            cell.label_Name.text = peripheral.name
            cell.label_MacAddr.text = peripheral.identifier.uuidString
            
//            let dis = Float(calculateBluetoothDistance(rssi: mainArrayRSSI[indexPath
//                .row]))
//            let distance = String.init(format: "%.01f", dis / 100.0)
//            cell.label_Distance.text = String.init("距离: \(distance)M")
        }
        
        cell.layer.shadowRadius = 20.0
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowOpacity = 1.0
        cell.clipsToBounds = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RappleActivityIndicatorView.startAnimatingWithLabel("正在连接...", attributes:  RappleAppleAttributes)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        stopScan()
        let adv = mainAdvDataArray[indexPath.row]
        print(adv)
        let index = adv.index(forKey: "kCBAdvDataManufacturerData")
        if index != nil {
            let data = adv[index!].value
            print(data)
            switch data {
            case is Data:
                let int = String(describing: data)
                print(int)
                let int2 = int as NSString
                print(int2)
                let suffix = int2.substring(with: NSRange.init(location: 20, length: 1))
                print(suffix)
                mainPeripheralMACAddres = suffix
                
                isCheckTheDFU = true
                
                if mainPeripheral !== nil {
                    isConnectToNewPeripharal = true
                    mainCentralManager.cancelPeripheralConnection(mainPeripheral!)
                    mainPeripheral = nil
                }
                mainPeripheral = mainArrayPeripheral[indexPath.row]
                mainPeripheral?.delegate = self
                mainCentralManager.connect(mainPeripheral!, options: nil)
            default:
                print("ddd")
            }
        }
        
        
        
        
        
        viewContainsTableView.removeFromSuperview()
        mainTableView.removeFromSuperview()
        //        mainArrayRSSI.removeAll()
        mainArrayPeripheral.removeAll()
    }
    
    
    
    public func createTableView() -> Void {
        
        if isBluetoothOpened {
            viewContainsTableView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 50, height: self.view.frame.size.height / 5 * 2))
            viewContainsTableView.center = self.view.center
            self.view.addSubview(viewContainsTableView)
            viewContainsTableView.backgroundColor = UIColor.white
            viewContainsTableView.layer.cornerRadius = 20
            viewContainsTableView.layer.shadowRadius = 5.0
            viewContainsTableView.layer.shadowColor = UIColor.gray.cgColor
            viewContainsTableView.layer.shadowOffset = CGSize(width: 5, height: 5)
            viewContainsTableView.layer.shadowOpacity = 1.0
            viewContainsTableView.clipsToBounds = false
            
            let label_ContainsTitle = UILabel()
            viewContainsTableView.addSubview(label_ContainsTitle)
            label_ContainsTitle.whc_Left(20).whc_Top(10).whc_Width(150).whc_Height(30)
            label_ContainsTitle.font = UIFont.systemFont(ofSize: 15)
            label_ContainsTitle.textColor = UIColor.green
            label_ContainsTitle.textAlignment = .left
            label_ContainsTitle.text = "已找到的设备:"
            
            let button_Cancel  = UIButton(type: .roundedRect)
            viewContainsTableView.addSubview(button_Cancel)
            button_Cancel.whc_CenterYEqual(label_ContainsTitle).whc_Right(20).whc_Width(30).whc_Height(30)
            button_Cancel.setImage(UIImage.init(named: "menu_cancel_"), for: .normal)
            button_Cancel.addTarget(self, action: #selector(buttonAction_Cancel), for: .touchUpInside)
            
            mainTableView = UITableView(frame: CGRect(x: 0, y: 40, width: viewContainsTableView.frame.width, height: viewContainsTableView.frame.height - 40), style: .plain)
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.tableFooterView = UIView()
            mainTableView.backgroundColor = UIColor.clear
            mainTableView.register(SCTDiscoveredBLETableViewCell.self, forCellReuseIdentifier: "cell")
            viewContainsTableView.addSubview(mainTableView)
            mainTableView.layer.shadowRadius = 20.0
            mainTableView.layer.shadowColor = UIColor.gray.cgColor
            mainTableView.layer.shadowOffset = CGSize(width: 5, height: 5)
            mainTableView.layer.shadowOpacity = 1.0
            mainTableView.clipsToBounds = true
            
        }
    }

    @objc fileprivate func buttonAction_Cancel() -> Void {
        isCheckTheDFU = false
        viewContainsTableView.removeFromSuperview()
        mainTableView.removeFromSuperview()
//        mainArrayRSSI.removeAll()
        mainArrayPeripheral.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MainViewController {
    
    func startScan() -> Void {
        
        isDidDiscoveredPeripharal = false
        if isBluetoothOpened {
            RappleActivityIndicatorView.startAnimatingWithLabel("搜索蓝牙...", attributes:  RappleModernAttributes)
            createTableView()
            mainCentralManager.scanForPeripherals(withServices: [], options: nil)
            mainTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction_TimeOut), userInfo: nil, repeats: false)
        }else {
            let view = MessageView.viewFromNib(layout: MessageView.Layout.CardView)
            view.configureTheme(Theme.error)
            view.configureContent(title: "蓝牙未打开", body: "请先打开手机蓝牙!")
            view.configureTheme(backgroundColor: UIColor.cyan, foregroundColor: UIColor.white)
            view.button?.isHidden = true
            var config = SwiftMessages.Config()
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
            config.duration = .seconds(seconds: 1.0)
            config.dimMode = .gray(interactive: true)
            config.interactiveHide = true
            SwiftMessages.show(config: config, view: view)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc private func timerAction_TimeOut() -> Void {
        
        mainTimer?.invalidate()
        if isDidDiscoveredPeripharal == false {
            RappleActivityIndicatorView.stopAnimating(showCompletion: true, completionLabel: "未找到蓝牙", completionTimeout: 1.0)
//            buttonAction_Cancel()
            
            let view = MessageView.viewFromNib(layout: MessageView.Layout.CardView)
            view.configureTheme(Theme.error)
            view.configureContent(title: "请重试", body: "未搜索到蓝牙设备!")
            view.configureTheme(backgroundColor: UIColor.cyan, foregroundColor: UIColor.white)
            view.button?.isHidden = true
            var config = SwiftMessages.Config()
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
            config.duration = .seconds(seconds: 1.0)
            config.dimMode = .gray(interactive: true)
            config.interactiveHide = true
//            SwiftMessages.show(config: config, view: view)

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func stopScan() -> Void {
        mainCentralManager.stopScan()
    }
    
    func sendData(data: NSData)-> Void{
        mainPeripheral?.writeValue(data as Data, for: mainCharacteristicTX!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    ///bluetooth status
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            
            isBluetoothOpened = true

        default:
            
            isBluetoothOpened = false
            isBluetoothConnected = false
//            sendBluetoothDidDisconnectedNotification()
        }
    }
    
    private func sendBluetoothDidDisconnectedNotification() -> Void {
        
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "BluetoothDidDisconnected"), object: nil, userInfo: nil)
        
        if isConnectToNewPeripharal == false {
            let view = MessageView.viewFromNib(layout: MessageView.Layout.CardView)
            view.configureTheme(backgroundColor: UIColor.red, foregroundColor: UIColor.white)
            view.configureContent(title: "请注意", body: "蓝牙设备已断开连接!")
            view.configureTheme(Theme.error, iconStyle: IconStyle.default)
            view.button?.isHidden = true
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
            config.presentationStyle = .top
            config.dimMode = .gray(interactive: true)
            config.duration = .forever
            config.interactiveHide = true
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    /// did found peripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        RappleActivityIndicatorView.stopAnimating(showCompletion: true, completionLabel: "找到蓝牙", completionTimeout: 1.0)
        isDidDiscoveredPeripharal = true
        //        stopScan()
        
        print("rssi:" +  RSSI.stringValue)
        mainArrayPeripheral.append(peripheral)
        mainAdvDataArray.append(advertisementData)
//        mainArrayRSSI.append(RSSI)
//        print(mainArrayPeripheral)
        print("\(#function)")
        print(advertisementData)
//        print("peripheral name:" + (peripheral.name!))
        if isCheckTheDFU {
            RappleActivityIndicatorView.startAnimatingWithLabel("查找 DFU 设备")
            let index = advertisementData.index(forKey: "kCBAdvDataManufacturerData")
            if index != nil {
                let data = advertisementData[index!].value
                print(data)
                switch data {
                case is Data:
                    let int = String(describing: data)
                    print(int)
                    let int2 = int as NSString
                    print(int2)
                    let suffix = int2.substring(with: NSRange.init(location: 20, length: 1))
                    print(suffix)
                    if Int(suffix)! - Int(mainPeripheralMACAddres)! == 1 {
                        print("1111111")
                        stopScan()
                        
                        block_DDDD(mainCentralManager, peripheral)
                        mainAdvDataArray.removeAll()
                        mainArrayPeripheral.removeAll()
                        isCheckTheDFU = false
                        viewContainsTableView.removeFromSuperview()
                        mainTableView.removeFromSuperview()
                    }
                    
                    
                default:
                    print("dddff")
                }
            }
        }
        mainTableView.reloadData()
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        
        RappleActivityIndicatorView.startAnimatingWithLabel("设备已成功连接")
        isBluetoothConnected = true
//        print(peripheral.name,peripheral.services)
        RappleActivityIndicatorView.startAnimatingWithLabel("查找服务")
        mainPeripheral?.discoverServices([])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("\(#function)")
        for service: CBService in peripheral.services! {
            print(service.uuid)
            if service.uuid.isEqual(CBUUID.init(string: UUID_DFUServices)) {
                RappleActivityIndicatorView.startAnimatingWithLabel("已找到服务")
                mainPeripheral?.discoverCharacteristics([CBUUID.init(string: UUID_DFUCharacteristics)], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        RappleActivityIndicatorView.startAnimatingWithLabel("开启 BootLoader")
        print("\(#function)")
        for characteristic: CBCharacteristic in service.characteristics! {
            
            if characteristic.uuid.isEqual(CBUUID.init(string: UUID_DFUCharacteristics)) {
                mainCharacteristicTX = characteristic
                mainPeripheral?.setNotifyValue(true, for: characteristic)
                print("34terf")
                
                var byte = [CUnsignedChar]()
                byte.append(0x01)
                byte.append(0x04)
                sendData(data: NSData(bytes: byte, length: 2))
                
//                mainCentralManager.cancelPeripheralConnection(mainPeripheral!)
//                block_DDDD(mainCentralManager, mainPeripheral!)
                self.dismiss(animated: true, completion: nil)
                mainCentralManager.scanForPeripherals(withServices: [], options: nil)
                mainTimer2 = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(timerAction2), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func timerAction2() -> Void {
        
        RappleActivityIndicatorView.stopAnimating(showCompletion: true, completionLabel: "开启 BootLoader 失败", completionTimeout: 2.0)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
//        if characteristic.uuid.isEqual(CBUUID.init(string: UUID_Notification_Heart_Rate)) {
//            
//            let data: NSData = characteristic.value! as NSData
//            handleHeartRate(data: data)
//        }
       
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        print("\(#function)")
//        sendBluetoothDidDisconnectedNotification()
    }
    
    
    private func sendDataToOpenServaralSwitcher() -> Void {
        ///打开总开关
        var byte = [CUnsignedChar]()
        byte.append(0x08)
        sendData(data: NSData(bytes: byte, length: 1))
        /// 打开计步开关
        byte = [CUnsignedChar]()
        byte.append(0x06)
        byte.append(0x01)
        sendData(data: NSData(bytes: byte, length: 2))
        /// 请求历史计步数据
        byte = [CUnsignedChar]()
        byte.append(0x01)
        sendData(data: NSData(bytes: byte, length: 1))
        /// 设置计步模式为其他; 0:室内,1:室外,2: 其他
        byte = [CUnsignedChar]()
        byte.append(0x02)
        byte.append(2)
        sendData(data: NSData(bytes: byte, length: 2))
        /// 计步开始 1:开始, 0: 暂停
        byte = [CUnsignedChar]()
        byte.append(0x03)
        byte.append(0x01)
        sendData(data: NSData(bytes: byte, length: 2))
        /// 打开心率通知开关 0x01: 开, 0x00: 关
        byte = [CUnsignedChar]()
        byte.append(0x01)
        byte.append(0x01)
        sendData(data: NSData(bytes: byte, length: 2))
    }
    

    
    
}

