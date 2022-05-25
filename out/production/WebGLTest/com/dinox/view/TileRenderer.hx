package com.dinox.view;
import com.dinox.model.tile.TileRarityType;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.IGContext;
import com.genome2d.tilemap.GTile;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
class TileRenderer {
    public static var NORMAL_STATE: String = "normal";
    public static var SMALL_STATE: String = "small";
    public static var LARGE_STATE: String = "large";

    private var tmpTileId_n: String = "tile_n";
    private var tmpTileId_l: String = "tile_l";
    private var tmpTileId_s: String = "tile_s";

    public static var ZOOM_BREAKPOINT_SMALL: Float = 0.85;
    public static var ZOOM_BREAKPOINT_LARGE: Float = 1.25;
    public static var BASE_TILE_SIZE: Int = 60;

    private var  gTile: GTile;

    private var l_separator: GTexture = null;
    private var r_separator: GTexture = null;
    private var t_separator: GTexture = null;
    private var b_separator: GTexture = null;

    private var commonColor: Array<Float> = [.48, .48, .46];
    private var uncommonColor: Array<Float> = [.07, .61, .28];
    private var rareColor: Array<Float> = [.24, .46, .73];
    private var legendaryColor: Array<Float> = [.83, .55, .16];
    private var mythicalColor: Array<Float> = [.63, .34, .63];

    private var assetState: String;
    public function new(p_x: Int, p_y: Int) {
        gTile = new GTile(BASE_TILE_SIZE, BASE_TILE_SIZE, p_x, p_y);

        gTile.texture = GTextureManager.getTexture("tile_n");
    }

    public function addTopSeparator(): Void {
        l_separator = GTextureManager.getTexture("separator_v");
        l_separator.pivotX = 0;
        l_separator.pivotY = 0.5;
    }

    public function addBottomSeparator(): Void {
        r_separator = GTextureManager.getTexture("separator_v");
        r_separator.pivotX = 1;
        r_separator.pivotY = 0.5;
    }

    public function addLeftSeparator(): Void {
        t_separator = GTextureManager.getTexture("separator_h");
        t_separator.pivotX = 0.5;
        t_separator.pivotY = 0;
    }

    public function addRightSeparator(): Void {
        b_separator = GTextureManager.getTexture("separator_h");
        b_separator.pivotX = 0.5;
        b_separator.pivotY = 1;
    }

    public function renderSeparators(p_context:IGContext, p_x:Float, p_y:Float, p_blendMode:GBlendMode): Void {

        if(l_separator != null) {
            p_context.draw(l_separator, p_blendMode, p_x - BASE_TILE_SIZE/2, p_y, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(r_separator != null) {
            p_context.draw(r_separator, p_blendMode, p_x + BASE_TILE_SIZE/2, p_y, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(t_separator != null) {
            p_context.draw(t_separator, p_blendMode, p_x, p_y - BASE_TILE_SIZE/2, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(b_separator != null) {
            p_context.draw(b_separator, p_blendMode, p_x, p_y + BASE_TILE_SIZE/2, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
    }

    public function dimHighlight(): Void {
        gTile.alpha = 0.5;
        gTile.red = 1;
        gTile.blue = 1;
        gTile.green = 1;
    }

    public function highlightTile(p_rarity: String): Void {
        gTile.alpha = 1.5;
        var r: Float = 0;
        var g: Float = 0;
        var b: Float = 0;
        switch(p_rarity) {
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

    }

    public function resetHighlight(): Void {
        gTile.alpha = 1;
        gTile.red = 1;
        gTile.blue = 1;
        gTile.green = 1;
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

    public function render(p_context:IGContext, p_x:Float, p_y:Float, p_frameId:Int, p_time:Float, p_blendMode:GBlendMode): Void {
        gTile.render(p_context, p_x, p_y, p_frameId, p_time, p_blendMode);
//        gTile.render(p_context, p_x - BASE_TILE_SIZE/2, p_y - BASE_TILE_SIZE/2, p_frameId, p_time, p_blendMode);
//        renderSeparators(p_context, p_x - BASE_TILE_SIZE/2, p_y - BASE_TILE_SIZE/2, p_blendMode);
        renderSeparators(p_context, p_x, p_y, p_blendMode);
    }
}
