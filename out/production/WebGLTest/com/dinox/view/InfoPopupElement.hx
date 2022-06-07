package com.dinox.view;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class InfoPopupElement {

    private var popupXml: Xml = GStaticAssetManager.getXmlAssetById("popup_element").xml;
    private var popupElement: GUIElement;


    public function new(p_data: Map<String, Dynamic>) {
        popupElement = new GUIElement();
        popupElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(popupXml.toString());
        popupElement.getChildByName("info_popup_title", true).model = "X => " + p_data.get("x") + " Y => " + p_data.get("y");
//        popupElement.getChildByName("info_popup_title", true).model = cast p_data;
        popupElement.flushBatch = true;
    }

    public function getGuiElement(): GUIElement {
        return  popupElement;
    }

}
