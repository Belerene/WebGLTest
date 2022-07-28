package com.dinox.model.tile;
class Land {
    private var id: Int;
    private var x: Int;
    private var y: Int;
    private var size: Int;
    private var rarity: Int;
    private var ownedBy: String;
    private var assets: Array<Int>;
    private var tiles: Array<Tile>;

    public function new(p_id: Int, p_x: Int, p_y: Int, p_size: Int, p_rarity: Int, p_ownedBy: String, p_assets: Array<Int>, p_tiles: Array<Tile>) {
        id = p_id;
        x = p_x;
        y = p_y;
        size = p_size;
        rarity = p_rarity;
        ownedBy = p_ownedBy;
        processAssets(p_assets);
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
                tiles[index].setOwnedBy(ownedBy);
                index++;
                assetIndex++;
            }
        }
        invalidateSeparators();
    }

    private function processAssets(p_assets: Array<Int>): Void {
        assets = new Array<Int>();
        for(i in 0...p_assets.length) {
            assets.push(cast(p_assets[i], Int));
        }
    }

    private function invalidateSeparators(): Void {
        var index: Int = 0;
        for(i in x...x+size) {
            for(j in y...y+size) {
                if(i == x) {
                    tiles[index].addLeftSeparator();
                }
                if(i == x+size-1) {
                    tiles[index].addRightSeparator();
                }
                if(j == y) {
                    tiles[index].addTopSeparator();
                }
                if(j == y+size-1) {
                    tiles[index].addBottomSeparator();
                }
                index++;
            }
        }
    }

    public function setRarity(p_rarity: Int): Void {
        if(p_rarity == rarity) return;
        rarity = p_rarity;
        for(i in 0...tiles.length) {
            tiles[i].setTileLandRarity(rarity);
        }
        invalidateSeparators();
    }

    public function getRarity(): Int {
        return rarity;
    }

    public function getOwner(): String {
        return ownedBy;
    }

    public function getX(): Int {
        return x;
    }

    public function getY(): Int {
        return y;
    }

    public function setSize(p_size: Int): Void {
        if(p_size == size) return;
        var originalAssets: Array<Int> = assets;
        var originalSize: Int = size;
        size = p_size;
        var sizeDiff: Int = originalSize - size;
        var defaultTile: Tile;
        var originalTiles: Array<Tile> = tiles.copy();
        for(i in 0...tiles.length) {
            defaultTile = new Tile(tiles[i].getGTile().mapX, tiles[i].getGTile().mapY, 1, size, ownedBy);
            tiles[i] = defaultTile;
        }
        var index: Int = 0;
        var originalIndex: Int = 0;
        assets = new Array<Int>();
        tiles = new Array<Tile>();
        for(i in x...x+size) {
            for(j in y...y+size) {
                if(i >= x+originalSize || j >= y+originalSize) {
                    tiles.push(originalTiles[originalTiles.length-1].clone());
                    tiles[index].setX(i);
                    tiles[index].setY(j);
                    tiles[index].setTileAssetData(assets[originalTiles.length-1]);
                    assets.push(originalAssets[originalTiles.length-1]);
                } else {
                    tiles.push(originalTiles[originalIndex].clone());
                    assets.push(originalAssets[originalIndex]);
                    tiles[index].setTileAssetData(originalTiles[originalIndex].getAssetId());
                    originalIndex++;
                }
                tiles[index].setTileLandSize(size);
                tiles[index].tileIsInLand = true;
                index++;

                if(j == (y+size-1)) {
                    if(sizeDiff > 0) {
                        originalIndex += sizeDiff;
                    }
                }
            }
        }
        invalidateSeparators();
    }

    public function getSize(): Int {
        return size;
    }

    public function getAssets(): Array<Int> {
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
        var res: Land = new Land(id, x, y, size, rarity, ownedBy, assets, tiles.copy());
        return res;
    }
    public function getRarityAsString(): String {
        switch(rarity) {
            case 1: return "common";
            case 2: return "uncommon";
            case 3: return "rare";
            case 4: return "legendary";
            case 5: return "mythical";
        }
        return "";
    }
}
