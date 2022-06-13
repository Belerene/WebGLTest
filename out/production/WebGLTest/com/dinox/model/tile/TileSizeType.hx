package com.dinox.model.tile;
class TileSizeType {
    inline static public var DEFAULT:Int = 0;
    inline static public var ONEXONE:Int = 1;
    inline static public var TWOXTWO:Int = 2;
    inline static public var THREEXTHREE:Int = 3;
    inline static public var FOURXFOUR:Int = 4;

    public static function lowerSize(p_size: Int): Int {
        if(p_size == ONEXONE) return p_size;
        return p_size -= 1;
    }

    public static function higherSize(p_size: Int): Int {
        if(p_size == FOURXFOUR) return p_size;
        return p_size += 1;
    }
}
