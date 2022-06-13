package com.dinox.model.tile;
class TileRarityType {
    inline static public var DEFAULT:String = "default";
    inline static public var COMMON:String = "common";
    inline static public var UNCOMMON:String = "uncommon";
    inline static public var RARE:String = "rare";
    inline static public var LEGENDARY:String = "legendary";
    inline static public var MYTHICAL:String = "mythical";

    private static var rarityList: Array<String> = [COMMON, UNCOMMON, RARE, LEGENDARY, MYTHICAL];

    public static function lowerRarity(p_current: String): String {
        var index: Int = rarityList.indexOf(p_current);
        if(index == 0) return p_current;
        return rarityList[index-1];
    }

    public static function higherRarity(p_current: String): String {
        var index: Int = rarityList.indexOf(p_current);
        if(index == rarityList.length-1) return p_current;
        return rarityList[index+1];
    }
}
