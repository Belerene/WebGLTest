package com.dinox.model.tile;
import com.genome2d.debug.GDebug;
class Land {
    private var id: Int;
    private var x: Int;
    private var y: Int;
    private var size: Int;
    private var rarity: String;
    private var assets: Array<String>;
    private var tiles: Array<Tile>;

    public function new(p_id: Int, p_x: Int, p_y: Int, p_size: Int, p_rarity: String, p_assets: Array<String>, p_tiles: Array<Tile>) {
        id = p_id;
        x = p_x;
        y = p_y;
        size = p_size;
        rarity = p_rarity;
        assets = p_assets;
        tiles = p_tiles;

        var dataToPropagate: Map<String, Dynamic>  = tiles[0].userData;
        var index: Int = 0;
        var assetIndex: Int = 0;
        for(i in p_x...p_x+p_size) {
            for(j in p_y...p_y+p_size) {
                tiles[index].tileIsInLand = true;
                tiles[index].userData = cast dataToPropagate;
                tiles[index].id = p_id;
                tiles[index].setTileAssetData(TrimAssetString(assets[assetIndex]));
                tiles[index].setTileLandRarity(p_rarity);
                tiles[index].setTileLandSize(p_size);
                if(i == p_x) {
                    tiles[index].addTopSeparator();
                }
                if(i == p_x+p_size-1) {
                    tiles[index].addBottomSeparator();
                }
                if(j == p_y) {
                    tiles[index].addLeftSeparator();
                }
                if(j == p_y+p_size-1) {
                    tiles[index].addRightSeparator();
                }
                index++;
                assetIndex++;
            }
        }
    }

    public function containsTile(p_tile: Tile): Bool {
        for(i in 0...tiles.length) {
            if(p_tile == tiles[i]) {
                return true;
            }
        }
        return false;
    }

    public function getTiles(): Array<Tile>{
        if(tiles == null) {
            tiles = new Array<Tile>();
        }
        return tiles;
    }

    public function setTiles(p_tiles: Array<Tile>): Void {
        tiles = p_tiles;
    }

    public function moveTiles(p_moveByX: Int, p_moveByY: Int): Void {
        GDebug.info("moveByX: " + p_moveByX + " moveByY: " + p_moveByY);
        for(i in 0...tiles.length) {
            tiles[i].getGTile().mapX += p_moveByX;
            tiles[i].getGTile().mapY += p_moveByY;
        }
    }

    public static function TrimAssetString(p_asset: String): String {
        var res: String = StringTools.replace(p_asset,"'","");
        res = StringTools.replace(res,"[","");
        res = StringTools.replace(res,"]","");
        res = StringTools.trim(res);
        return res;
    }
}
