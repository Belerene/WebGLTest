package com.dinox.view;
import com.genome2d.debug.GDebug;
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

    private var tileAsset_n: GTexture = null;
    private var tileAsset_l: GTexture = null;
    private var tileAsset_s: GTexture = null;
    private var asset: String = "";

    public static var ZOOM_BREAKPOINT_SMALL: Float = 0.25;
    public static var ZOOM_BREAKPOINT_LARGE: Float = 1.25;
    public static var BASE_TILE_SIZE: Int = 60;

    private var  gTile: GTile;

    private var l_separator: GTexture = null;
    private var r_separator: GTexture = null;
    private var t_separator: GTexture = null;
    private var b_separator: GTexture = null;
    private var full_separator: GTexture = null;

    private var currentZoom: Float = 1;

    private var commonColor: Array<Float> = [.48, .48, .46];
    private var uncommonColor: Array<Float> = [.07, .61, .28];
    private var rareColor: Array<Float> = [.24, .46, .73];
    private var legendaryColor: Array<Float> = [.83, .55, .16];
    private var mythicalColor: Array<Float> = [.63, .34, .63];

    private var assetState: String;
    public function new(p_x: Int, p_y: Int) {
        gTile = new GTile(BASE_TILE_SIZE, BASE_TILE_SIZE, p_x, p_y);

        setNewTileAssets("default");

    }

    public function updateSeparators(p_rarity:String, p_top:Int, p_right:Int, p_bottom:Int, p_left:Int): Void {
        var separatorString: String = p_top == 1? "n" : "";
        separatorString += p_right == 1? "e" : "";
        separatorString += p_bottom == 1? "s" : "";
        separatorString += p_left == 1? "w" : "";
//        GDebug.info("SEPARATOR:: " + separatorString + " RARITY: " + p_rarity);

        full_separator = GTextureManager.getTexture('assets/atlas.png_separator_' + p_rarity + '_' + separatorString);
        if(separatorString == "w" && full_separator != null) {
            GDebug.info("SEPARATOR STRING: W RARITY: " + p_rarity + " FULL SEPARATOR: "+ full_separator.toString());
        }
    }

    public function addTopSeparator(p_rarity: String): Void {
        l_separator = GTextureManager.getTexture("separator_v_" + p_rarity);
        l_separator.pivotX = 0;
        l_separator.pivotY = 0.5;
    }

    public function addBottomSeparator(p_rarity: String): Void {
        r_separator = GTextureManager.getTexture("separator_v_" + p_rarity);
        r_separator.pivotX = 1;
        r_separator.pivotY = 0.5;
    }

    public function addLeftSeparator(p_rarity: String): Void {
        t_separator = GTextureManager.getTexture("separator_h_" + p_rarity);
        t_separator.pivotX = 0.5;
        t_separator.pivotY = 0;
    }

    public function addRightSeparator(p_rarity: String): Void {
        b_separator = GTextureManager.getTexture("separator_h_" + p_rarity);
        b_separator.pivotX = 0.5;
        b_separator.pivotY = 1;
    }

    public function renderSeparators(p_context:IGContext, p_x:Float, p_y:Float, p_blendMode:GBlendMode): Void {
        if (full_separator != null && currentZoom >= 0.2) {
            p_context.draw(full_separator, p_blendMode, p_x, p_y, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        /*if(l_separator != null) {
            p_context.draw(l_separator, p_blendMode, (p_x + 2) - BASE_TILE_SIZE/2, p_y, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(r_separator != null) {
            p_context.draw(r_separator, p_blendMode, p_x + BASE_TILE_SIZE/2, p_y + 1, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(t_separator != null) {
            p_context.draw(t_separator, p_blendMode, p_x + 1, (p_y + 2) - BASE_TILE_SIZE/2, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }
        if(b_separator != null) {
            p_context.draw(b_separator, p_blendMode, p_x, p_y + BASE_TILE_SIZE/2, gTile.scaleX, gTile.scaleY, gTile.rotation, gTile.red, gTile.green, gTile.blue, gTile.alpha, null);
        }*/
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
        currentZoom = p_zoom;
        if(currentZoom <= ZOOM_BREAKPOINT_SMALL) {
            gTile.texture = tileAsset_l;
        } else if (currentZoom > ZOOM_BREAKPOINT_SMALL && currentZoom < ZOOM_BREAKPOINT_LARGE) {
            gTile.texture = tileAsset_l;
        } else if (currentZoom >= ZOOM_BREAKPOINT_LARGE) {
            gTile.texture = tileAsset_l;
        }
    }

    public function setNewTileAssets(p_asset: String): Void {
        if(p_asset != asset) {
            if(p_asset == "default") {
                tileAsset_n = GTextureManager.getTexture(getRandomLargeDefaultAsset());
                tileAsset_l = GTextureManager.getTexture(getRandomLargeDefaultAsset());
                tileAsset_s = GTextureManager.getTexture(getRandomLargeDefaultAsset());
            } else {
                tileAsset_n = GTextureManager.getTexture('assets/atlas.png_'+p_asset + "_n");
                tileAsset_l = GTextureManager.getTexture('assets/atlas.png_'+p_asset + "_l");
                tileAsset_s = GTextureManager.getTexture('assets/atlas.png_'+p_asset + "_s");
            }
            // just to  re-render the tile with new graphics
            zoomChanged(currentZoom);
            asset = p_asset;
        }
    }

    public function getGTile(): GTile {
        return gTile;
    }

    public function render(p_context:IGContext, p_x:Float, p_y:Float, p_frameId:Int, p_time:Float, p_blendMode:GBlendMode): Void {
        gTile.render(p_context, p_x, p_y, p_frameId, p_time, p_blendMode);
        renderSeparators(p_context, p_x, p_y, p_blendMode);
    }

    public function getRandomLargeDefaultAsset(): String {
        var rnd: Float = Math.random();
        if(rnd < 0.8) return "assets/atlas.png_default_l_1";
        if(rnd < 0.85) return "assets/atlas.png_default_l_2";
        if(rnd < 0.9) return "assets/atlas.png_default_l_3";
        if(rnd < 0.95) return "assets/atlas.png_default_l_4";
        return "assets/atlas.png_default_l_5";
    }
}
