package com.dinox.model;
import com.genome2d.debug.GDebug;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.tilemap.GTile;
import com.genome2d.ui.element.GUIElement;
import com.dinox.view.TileRenderer;
class Tile extends GTile{
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


    private var tileRenderer: TileRenderer;
    public function new(p_x: Int, p_y: Int, p_rarity: String, p_size: String) {
        super(TileRenderer.BASE_TILE_SIZE, TileRenderer.BASE_TILE_SIZE, p_x, p_y);
        rarity = p_rarity;
        landSize = p_size;
        texture = GTextureManager.getTexture("tile_n");
    }

    private function dimHighlight(): Void {
        alpha = 0.5;
    }

    private function highlightTile(): Void {
        alpha = 1.5;
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
        red = r;
        green = g;
        blue = b;
    }

    private function resetHighlight(): Void {
        alpha = 1;
        red = 1;
        blue = 1;
        green = 1;
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
            texture = GTextureManager.getTexture("tile_s");
        } else if (p_zoom > ZOOM_BREAKPOINT_SMALL && p_zoom < ZOOM_BREAKPOINT_LARGE) {
            texture = GTextureManager.getTexture("tile_n");
        } else if (p_zoom >= ZOOM_BREAKPOINT_LARGE) {
            texture = GTextureManager.getTexture("tile_l");
        }
    }

    public function getTileElement(): GUIElement {
        return tileRenderer.getTileElement();
    }
}
