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
        color = 0x9B1FE8;
    }

    private function resetHighlight(): Void {
        alpha = 1;
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
