//
//  VersionAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 10/10/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getVersion(onSuccess: ((String) -> Void)? = nil, onFailure: (() -> Void)? = nil) {
        let path = APIPath.version
        service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ (entity) in
                guard let data = entity.jsonDict["data"] as? [String:Any], let version = data["appVersion"] as? String else { return }
                onSuccess?(version)
            })
            .onFailure({ (error) in
                onFailure?()
            })
            .onCompletion({ (respone) in
                
            })
    }
    func cancelVersion() {
        self.cancel(APIPath.version)
    }
}
