package com.dinox.view;
import com.genome2d.debug.GDebug;
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

    private var tileXml: Xml = GStaticAssetManager.getXmlAssetById("tile").xml;
    private var tileElement: GUIElement;


    private var assetState: String;
    public function new(p_assetId_n: String, p_assetId_s: String, p_assetId_l: String) {

        tileElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(tileXml.toString());

    }


    public function getTileElement(): GUIElement {
        return tileElement;
    }
}
