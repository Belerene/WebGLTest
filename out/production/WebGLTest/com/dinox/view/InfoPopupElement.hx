package com.dinox.view;
import com.dinox.model.tile.Land;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class InfoPopupElement {

    private var popupXml: Xml = GStaticAssetManager.getXmlAssetById("popup_element").xml;
    private var popupElement: GUIElement;
    private var land: Land;


    public function new(p_land: Land) {
        popupElement = new GUIElement();
        popupElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(popupXml.toString());
        invalidate(p_land);
    }

    public function invalidate(p_land: Land): Void {
        land = p_land;
        popupElement.getChildByName("info_popup_title", true).model = "X: " + land.getX() + " Y: " + land.getY();
        popupElement.getChildByName("info_popup_rarity", true).model = "rarity: " + land.getRarity();
        popupElement.getChildByName("info_popup_size", true).model = "size: " + land.getSize();
//        popupElement.getChildByName("info_popup_asset", true).model = "asset: " + Std.string(land.getAssets());
        if(Main.IS_DEV) popupElement.setState("dev");
        popupElement.flushBatch = true;
    }

    public function getLand(): Land {
        return land;
    }

    public function getGuiElement(): GUIElement {
        return  popupElement;
    }

}
