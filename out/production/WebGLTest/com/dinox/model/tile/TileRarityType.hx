package com.dinox.model.tile;
class TileRarityType {
    inline static public var DEFAULT:String = "default";
    inline static public var COMMON:String = "common";
    inline static public var UNCOMMON:String = "uncommon";
    inline static public var RARE:String = "rare";
    inline static public var LEGENDARY:String = "legendary";
    inline static public var MYTHICAL:String = "mythical";

    inline static public var COMMON_COLOR: Int = 0xCACACA;
    inline static public var UNCOMMON_COLOR: Int = 0x5DC347;
    inline static public var RARE_COLOR: Int = 0x5AB8EE;
    inline static public var LEGENDARY_COLOR: Int = 0xFCB73B;
    inline static public var MYTHICAL_COLOR: Int = 0xB760D1;

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

    public static function getColorForRarity(p_rarity: String): Int {
        switch(p_rarity.toLowerCase()) {
            case MYTHICAL: return MYTHICAL_COLOR;
            case LEGENDARY: return LEGENDARY_COLOR;
            case RARE: return RARE_COLOR;
            case UNCOMMON: return UNCOMMON_COLOR;
            case COMMON: return COMMON_COLOR;
        }
        return 0x000000;
    }
}
