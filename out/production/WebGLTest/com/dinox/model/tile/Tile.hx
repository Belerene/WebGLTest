package com.dinox.model.tile;
import com.genome2d.debug.GDebug;
import com.genome2d.context.IGContext;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.GNode;
import com.genome2d.tilemap.GTile;
import com.dinox.view.TileRenderer;
class Tile {

    private var rarity: String;
    private var ownedBy: String;
    private var asset: String;
    private var landSize: Int;
    public var id: Int;

    private var _userData:Map<String, Dynamic>;
    public var userData(get, set):Map<String, Dynamic>;
    inline private function get_userData():Map<String, Dynamic> {
        if (_userData == null) _userData = new Map<String,Dynamic>();
        return _userData;
    }
    inline private function set_userData(p_data: Map<String, Dynamic>):Map<String, Dynamic> {
        if (_userData == null) _userData = new Map<String,Dynamic>();
        _userData = p_data;
        return _userData;
    }

    public var tileIsInLand: Bool = false;


    private var tileRenderer: TileRenderer;
    public function new(p_x: Int, p_y: Int, p_rarity: String, p_size: Int, p_ownedBy: String) {
        tileRenderer = new TileRenderer(p_x, p_y);

        rarity = p_rarity;
        landSize = p_size;
        ownedBy = p_ownedBy;
        _userData = ["rarity"=> p_rarity, "size"=> p_size, "x"=>  p_x, "y"=> p_y, "asset"=> "default", "ownedBy"=> p_ownedBy];


    }

    public function setTileAssetData(p_asset: String): Void {
        p_asset = TMP_generaterRandomAssetName();
        if(p_asset != null) {
            p_asset = Land.TrimAssetString(p_asset);
            if(p_asset != "") {
                tileRenderer.setNewTileAssets(p_asset);
                _userData.set("asset", p_asset);
            }
        }
    }

    private function TMP_generaterRandomAssetName(): String {
        var tileNumber: Int = Std.random(9) + 1;
        return "tile_" + Std.string(tileNumber);
    }

    public function getAsset(): String {
        return  _userData.get("asset");
    }

    public function setTileLandSize(p_size: Int): Void {
        if(p_size != null) {
            landSize = p_size;
            _userData.set("size", landSize);
        }
    }

    public function setOwnedBy(p_ownedBy: String): Void {
        if(p_ownedBy != "" || p_ownedBy != null) {
            ownedBy = p_ownedBy;
            _userData.set("ownedBy", ownedBy);
        }
    }

    public function setTileLandRarity(p_rarity: String): Void {
        if(p_rarity != null) {
            if(p_rarity != "") {
                rarity = p_rarity;
                _userData.set("rarity", rarity);
            }
        }
    }

    public function setX(p_x: Int): Void {
        _userData.set("x", p_x);
        getGTile().mapX = p_x;
    }

    public function setY(p_y: Int): Void {
        _userData.set("y", p_y);
        getGTile().mapY = p_y;
    }

    public function addTopSeparator(): Void {
        tileRenderer.addTopSeparator(rarity);
    }

    public function addBottomSeparator(): Void {
        tileRenderer.addBottomSeparator(rarity);
    }

    public function addLeftSeparator(): Void {
        tileRenderer.addLeftSeparator(rarity);
    }

    public function addRightSeparator(): Void {
        tileRenderer.addRightSeparator(rarity);
    }

    public function handleFilter(p_filters: Array<String>): Void {
        if(p_filters.length == 0) { tileRenderer.resetHighlight(); return; }
        var highlight: Bool = false;
        for(filter  in p_filters) {
            if(filter == rarity || filter == getSizeAsString() || filter == getOwnership()) {
                highlight = true;
            }
        }
        if(highlight) {
            tileRenderer.highlightTile(rarity);
        } else {
            tileRenderer.dimHighlight();
        }
    }

    private function getOwnership(): String {
        if(ownedBy == "Unowned") {
            return "unowned";
        } else if(ownedBy != "") {
            return "owned";
        }
        return "";
    }

    private function getSizeAsString(): String {
        switch(landSize) {
            case TileSizeType.ONEXONE: return "one";
            case TileSizeType.TWOXTWO: return "two";
            case TileSizeType.THREEXTHREE: return "three";
            case TileSizeType.FOURXFOUR: return "four";
        }
        return "";
    }

    public function zoomChanged(p_zoom: Float): Void {
        tileRenderer.zoomChanged(p_zoom);
    }

    public function getGTile(): GTile {
        return tileRenderer.getGTile();
    }

    public function render(p_context:IGContext, p_x:Float, p_y:Float, p_frameId:Int, p_time:Float, p_blendMode:GBlendMode): Void {
        tileRenderer.render(p_context, p_x, p_y, p_frameId, p_time, p_blendMode);
    }

    public static function getIndexFromCoordinates(p_x: Int, p_y: Int): Int {
        return p_y*LandMap.TILE_COUNT+p_x;
    }

    public function clone(): Tile {
        var res: Tile = new Tile(tileRenderer.getGTile().mapX, tileRenderer.getGTile().mapY, rarity, landSize, ownedBy);
        res.set_userData(_userData);
        return res;
    }
}
