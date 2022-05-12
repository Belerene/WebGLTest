package com.dinox.view;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
class TileRenderer {
    public static var NORMAL_STATE: String = "normal";
    public static var SMALL_STATE: String = "small";
    public static var LARGE_STATE: String = "large";
    public static var BASE_TILE_SIZE: Float = 60;

    private var tileXml: Xml = GStaticAssetManager.getXmlAssetById("tile").xml;
    private var tileElement: GUIElement;


    private var assetState: String;
    public function new(p_assetId_n: String, p_assetId_s: String, p_assetId_l: String) {

        tileElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(tileXml.toString());

        renderNormalTexture();
    }

    public function setPosition(p_x: Float, p_y: Float): Void {
        tileElement.anchorX = p_x;
        tileElement.anchorY = p_y;
//        tileSprite.node.setPosition(p_x, p_y);
    }

    public function renderNormalTexture(): Void {
        if(assetState!= NORMAL_STATE) {
            assetState = NORMAL_STATE;
            tileElement.setState(NORMAL_STATE);
        }
    }

    public function renderLargeTexture(): Void {
        if(assetState!= LARGE_STATE) {
            assetState = LARGE_STATE;
            tileElement.setState(LARGE_STATE);
        }
    }

    public function renderSmallTexture(): Void {
        if(assetState!= SMALL_STATE) {
            assetState = SMALL_STATE;
            tileElement.setState(SMALL_STATE);
        }
    }

    public function getTileElement(): GUIElement {
        return tileElement;
    }
}
