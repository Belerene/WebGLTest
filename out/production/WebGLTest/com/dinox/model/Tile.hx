package com.dinox.model;
import com.genome2d.context.IGContext;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.GNode;
import com.genome2d.debug.GDebug;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.tilemap.GTile;
import com.genome2d.ui.element.GUIElement;
import com.dinox.view.TileRenderer;
class Tile {
    private var tmpTileId_n: String = "tile_n";
    private var tmpTileId_l: String = "tile_l";
    private var tmpTileId_s: String = "tile_s";
    private var rarity: String;
    private var landSize: String;

    public var iIndex: Int;
    public var jIndex: Int;
    public var tileIsInGroup: Bool = false;

    public static var ZOOM_BREAKPOINT_SMALL: Float = 0.85;
    public static var ZOOM_BREAKPOINT_LARGE: Float = 1.25;
    public static var BASE_TILE_SIZE: Int = 60;

    private var commonColor: Array<Float> = [.48, .48, .46];
    private var uncommonColor: Array<Float> = [.07, .61, .28];
    private var rareColor: Array<Float> = [.24, .46, .73];
    private var legendaryColor: Array<Float> = [.83, .55, .16];
    private var mythicalColor: Array<Float> = [.63, .34, .63];

    private var l_separator: GTexture;
    private var r_separator: GTexture;
    private var t_separator: GTexture;
    private var b_separator: GTexture;

    private var  node: GNode;
    private var  gTile: GTile;


    private var tileRenderer: TileRenderer;
    public function new(p_x: Int, p_y: Int, p_rarity: String, p_size: String, p_node: GNode) {
        node = p_node;
        gTile = new GTile(BASE_TILE_SIZE, BASE_TILE_SIZE, p_x, p_y);
        // TMP data
        gTile.userData = cast Std.string(p_x) + ", " + Std.string(p_y);
        rarity = p_rarity;
        landSize = p_size;
        gTile.texture = GTextureManager.getTexture("tile_n");
        prepareSeparators();
    }

    private function prepareSeparators(): Void {
        l_separator = GTextureManager.getTexture("dev");
//        l_separator.width = 5;
//        l_separator.height = 65;
        l_separator.pivotX = 0;
        l_separator.pivotY = 0.5;

        r_separator = GTextureManager.getTexture("dev");
//        r_separator.width = 5;
//        r_separator.height = 65;
        r_separator.pivotX = 1;
        r_separator.pivotY = 0.5;

        t_separator = GTextureManager.getTexture("dev");
//        t_separator.width = 65;
//        t_separator.height = 5;
        t_separator.pivotX = 0.5;
        t_separator.pivotY = 0;

        b_separator = GTextureManager.getTexture("dev");
//        b_separator.width = 65;
//        b_separator.height = 5;
        b_separator.pivotX = 0.5;
        b_separator.pivotY = 1;

//        renderSeparators();
    }

//    override public function renderSeparators(p_context: IGContext): Void {
////        GDebug.info();
//        p_context.draw(l_separator, GBlendMode.NORMAL, mapX, mapY, scaleX, scaleY, rotation, red, green, blue, alpha, null);
//        p_context.draw(r_separator, GBlendMode.NORMAL, mapX, mapY, scaleX, scaleY, rotation, red, green, blue, alpha, null);
//        p_context.draw(t_separator, GBlendMode.NORMAL, mapX, mapY, scaleX, scaleY, rotation, red, green, blue, alpha, null);
//        p_context.draw(b_separator, GBlendMode.NORMAL, mapX, mapY, scaleX, scaleY, rotation, red, green, blue, alpha, null);
//    }

    private function dimHighlight(): Void {
        gTile.alpha = 0.5;
        gTile.red = 1;
        gTile.blue = 1;
        gTile.green = 1;
    }

    private function highlightTile(): Void {
        gTile.alpha = 1.5;
        var r: Float = 0;
        var g: Float = 0;
        var b: Float = 0;
        switch(rarity) {
            case TileRarityType.COMMON:
                r = commonColor[0];
                g = commonColor[1];
                b = commonColor[2];
            case TileRarityType.UNCOMMON:
                r = uncommonColor[0];
                g = uncommonColor[1];
                b = uncommonColor[2];
            case TileRarityType.RARE:
                r = rareColor[0];
                g = rareColor[1];
                b = rareColor[2];
            case TileRarityType.LEGENDARY:
                r = legendaryColor[0];
                g = legendaryColor[1];
                b = legendaryColor[2];
            case TileRarityType.MYTHICAL:
                r = mythicalColor[0];
                g = mythicalColor[1];
                b = mythicalColor[2];
        }
        gTile.red = r;
        gTile.green = g;
        gTile.blue = b;

        prepareSeparators();
    }

    private function resetHighlight(): Void {
        gTile.alpha = 1;
        gTile.red = 1;
        gTile.blue = 1;
        gTile.green = 1;
    }

    public function handleFilter(p_filters: Array<String>): Void {
        if(p_filters.length == 0) { resetHighlight(); return; }
        var highlight: Bool = false;
        for(filter  in p_filters) {
            if(filter == rarity || filter == landSize) {
                highlight = true;
            }
        }
        if(highlight) {
            highlightTile();
        } else {
            dimHighlight();
        }
    }

    public function zoomChanged(p_zoom: Float): Void {
        if(p_zoom <= ZOOM_BREAKPOINT_SMALL) {
            gTile.texture = GTextureManager.getTexture("tile_s");
        } else if (p_zoom > ZOOM_BREAKPOINT_SMALL && p_zoom < ZOOM_BREAKPOINT_LARGE) {
            gTile.texture = GTextureManager.getTexture("tile_n");
        } else if (p_zoom >= ZOOM_BREAKPOINT_LARGE) {
            gTile.texture = GTextureManager.getTexture("tile_l");
        }
    }

    public function getGTile(): GTile {
        return gTile;
    }

    public static function getIndexFromCoordinates(p_x: Int, p_y: Int): Int {
        return p_y*LandMap.TILE_COUNT+p_x;
    }
}
