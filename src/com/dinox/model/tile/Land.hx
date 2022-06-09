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
        for(i in x...x+size) {
            for(j in y...y+size) {
                tiles[index].tileIsInLand = true;
                tiles[index].userData = cast dataToPropagate;
                tiles[index].id = p_id;
                tiles[index].setTileAssetData(assets[assetIndex]);
                tiles[index].setTileLandRarity(p_rarity);
                tiles[index].setTileLandSize(size);
                index++;
                assetIndex++;
            }
        }
        invalidateSeparators();
    }

    private function invalidateSeparators(): Void {
        var index: Int = 0;
        for(i in x...x+size) {
            for(j in y...y+size) {
                if(i == x) {
                    tiles[index].addTopSeparator();
                }
                if(i == x+size-1) {
                    tiles[index].addBottomSeparator();
                }
                if(j == y) {
                    tiles[index].addLeftSeparator();
                }
                if(j == y+size-1) {
                    tiles[index].addRightSeparator();
                }
                index++;
            }
        }
    }

    public function setRarity(p_rarity: String): Void {
        GDebug.info("SETTING RARITY: " + p_rarity);
        if(p_rarity == rarity) return;
        rarity = p_rarity;
        for(i in 0...tiles.length) {
            tiles[i].setTileLandRarity(rarity);
        }
        invalidateSeparators();
    }

    public function getRarity(): String {
        return rarity;
    }

    public function getX(): Int {
        return x;
    }

    public function getY(): Int {
        return y;
    }

    public function setSize(p_size: Int): Void {
        if(p_size == size) return;
        var originalSize: Int = size;
        size = p_size;
        var sizeDiff: Int = originalSize - size;
        var defaultTile: Tile;
        var originalTiles: Array<Tile> = tiles.copy();
        for(i in 0...tiles.length) {
            GDebug.info("Setting default at x: " + tiles[i].getGTile().mapX + " y: " + tiles[i].getGTile().mapY);
            defaultTile = new Tile(tiles[i].getGTile().mapX, tiles[i].getGTile().mapY, TileRarityType.COMMON, size);
            tiles[i] = defaultTile;
        }
        var index: Int = 0;
        var originalIndex: Int = 0;
        assets.resize(tiles.length);
        tiles = new Array<Tile>();
        for(i in x...x+size) {
            for(j in y...y+size) {
                GDebug.info("i: " + i + " x+size: " + (x+originalSize) + " j: " + j + " y+size: " + (y+originalSize));
                if(i >= x+originalSize || j >= y+originalSize) {
//                }
                    tiles.push(originalTiles[originalTiles.length-1].clone());
                    tiles[index].setX(i);
                    tiles[index].setY(j);
                    tiles[index].setTileAssetData(assets[originalTiles.length-1]);
                    assets.push(assets[originalTiles.length-1]);
                } else {
                    GDebug.info("SETTING CLONE OF ORIGINAL INDEX: " + originalIndex + " X: " + i + " Y: " + j + " INDEX: " + index);
                    tiles.push(originalTiles[originalIndex].clone());
                    tiles[index].setTileAssetData(originalTiles[originalIndex].getAsset());
                    originalIndex++;
                }
                tiles[index].setTileLandSize(size);
                tiles[index].tileIsInLand = true;
                index++;

                if(j == (y+size-1)) {
//                    GDebug.info("Y: ")
                    if(sizeDiff > 0) {
                        originalIndex += sizeDiff;
                    }
                }
            }
        }
        invalidateSeparators();
//        GDebug.info("LAND TILES: " + Std.string(tiles));
    }

    public function getSize(): Int {
        return size;
    }

    public function getAssets(): Array<String> {
        return assets;
    }

    public function getId(): Int {
        return id;
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

    public function clone(): Land {
        var res: Land = new Land(id, x, y, size, rarity, assets, tiles.copy());
        return res;
    }
}
