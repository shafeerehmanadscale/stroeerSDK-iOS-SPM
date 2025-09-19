//
//  GraviteHelper.swift
//  YieldloveAdIntegration
//
//  Created by Hyungon Kim on 29/07/2024.
//
import Foundation


struct GraviteConstants {
    public static let logTag = "[GravitePlugin]"
}


class GraviteHelper {
    /**
     As gravite doesn't allow to use the '?' char, that char should be converted
     */
    public static func convertAdslot(placementTable: Dictionary <String, String>?, adSlot : String) -> String{
        if(placementTable == nil || placementTable?[adSlot] == nil)
        {
            return adSlot.replacingOccurrences(of: "?", with: "_")
        } else {
            return placementTable![adSlot]!
        }
    }
}
