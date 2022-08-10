package com.dinox.view;
import com.dinox.model.tile.TileSizeType;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.Land;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class InfoPopupElement {

    private static var MAX_OWNER_NAME_LEN: Int = 10;
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
        popupElement.getChildByName("info_popup_title", true).model = "X:" + land.getX() + "      Y:" + land.getY();
        popupElement.getChildByName("info_popup_title_id", true).model = "ID: #" + land.getId();
        popupElement.getChildByName("info_popup_rarity", true).model = land.getRarityAsString().charAt(0).toUpperCase() + land.getRarityAsString().substr(1);
        popupElement.getChildByName("info_popup_rarity", true).skin.color = TileRarityType.getColorForRarity(land.getRarityAsString());
        popupElement.getChildByName("info_popup_size", true).model = TileSizeType.sizeToString(land.getSize());
        popupElement.getChildByName("info_popup_owner", true).model = processOwnerName(land.getOwner());
//        popupElement.getChildByName("info_popup_asset", true).model = "asset: " + Std.string(land.getAssets());
        if(Main.IS_DEV) popupElement.setState("dev");
        popupElement.flushBatch = true;
    }

    private function processOwnerName(p_name: String): String {
        if(p_name.length > MAX_OWNER_NAME_LEN) {
            return p_name.substr(0, 5) + "..." + p_name.substr(p_name.length-3, p_name.length);
        }
        return p_name;
    }

    public function getLand(): Land {
        return land;
    }

    public function getGuiElement(): GUIElement {
        return  popupElement;
    }

}
