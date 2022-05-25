package com.dinox.model.tile;
import com.genome2d.context.IGContext;
import com.genome2d.context.GBlendMode;
import com.genome2d.node.GNode;
import com.genome2d.tilemap.GTile;
import com.dinox.view.TileRenderer;
class Tile {

    private var rarity: String;
    private var landSize: String;

    private var userData:Map<String, Dynamic>;

    public var tileIsInGroup: Bool = false;

    private var  node: GNode;

    private var tileRenderer: TileRenderer;
    public function new(p_x: Int, p_y: Int, p_rarity: String, p_size: String, p_node: GNode) {
        node = p_node;
        tileRenderer = new TileRenderer(p_x, p_y);

        // TMP data
        userData = cast Std.string(p_x) + ", " + Std.string(p_y);
        rarity = p_rarity;
        landSize = p_size;

    }

    public function addTopSeparator(): Void {
        tileRenderer.addTopSeparator();
    }

    public function addBottomSeparator(): Void {
        tileRenderer.addBottomSeparator();
    }

    public function addLeftSeparator(): Void {
        tileRenderer.addLeftSeparator();
    }

    public function addRightSeparator(): Void {
        tileRenderer.addRightSeparator();
    }

    public function handleFilter(p_filters: Array<String>): Void {
        if(p_filters.length == 0) { tileRenderer.resetHighlight(); return; }
        var highlight: Bool = false;
        for(filter  in p_filters) {
            if(filter == rarity || filter == landSize) {
                highlight = true;
            }
        }
        if(highlight) {
            tileRenderer.highlightTile(rarity);
        } else {
            tileRenderer.dimHighlight();
        }
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
}
