package com.dinox.model;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.node.GNode;
import com.dinox.view.TileRenderer;
class Tile {
    private var tmpTileId_n: String = "tile_n";
    private var tmpTileId_l: String = "tile_l";
    private var tmpTileId_s: String = "tile_s";
    private var currentZoom: Float = 1;

    public var iIndex: Int;
    public var jIndex: Int;
    public var tileIsInGroup: Bool = false;

    private static var ZOOM_BREAKPOINT_SMALL: Float = 0.85;
    private static var ZOOM_BREAKPOINT_LARGE: Float = 1.25;


    private var tileRenderer: TileRenderer;
    public function new(p_x: Float, p_y: Float, p_i: Int, p_j: Int) {
        iIndex = p_i;
        jIndex = p_j;
        tileRenderer = new TileRenderer(tmpTileId_n, tmpTileId_s, tmpTileId_l);
        tileRenderer.setPosition(p_x, p_y);
    }

    public function zoomChanged(p_zoom: Float): Void {
        if(p_zoom <= ZOOM_BREAKPOINT_SMALL) {
            tileRenderer.renderSmallTexture();
        } else if (p_zoom > ZOOM_BREAKPOINT_SMALL && p_zoom < ZOOM_BREAKPOINT_LARGE) {
            tileRenderer.renderNormalTexture();
        } else if (p_zoom >= ZOOM_BREAKPOINT_LARGE) {
            tileRenderer.renderLargeTexture();
        }
    }

    public function getTileElement(): GUIElement {
        return tileRenderer.getTileElement();
    }
}
