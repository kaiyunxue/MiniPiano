//
//  ServiceManagerDelegate.swift
//  MiniPiano
//
//  Created by Xue Kaiyun on 2018/4/17.
//  Copyright © 2018年 Xue Kaiyun. All rights reserved.
//

import Foundation
protocol ServiceManagerDelegate {
    
    func KeyPressed(keyId: Int)
    func KeyReleased(keyId: Int)
}
