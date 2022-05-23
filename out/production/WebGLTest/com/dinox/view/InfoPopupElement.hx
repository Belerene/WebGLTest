package com.dinox.view;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class InfoPopupElement {

    private var popupXml: Xml = GStaticAssetManager.getXmlAssetById("popup_element").xml;
    private var popupElement: GUIElement;


    public function new() {
        popupElement = new GUIElement();
        popupElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(popupXml.toString());
        popupElement.flushBatch = true;
    }

    public function getGuiElement(): GUIElement {
        return  popupElement;
    }

}
