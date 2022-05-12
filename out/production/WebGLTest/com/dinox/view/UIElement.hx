package com.dinox.view;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class UIElement {

    private var uiXml: Xml = GStaticAssetManager.getXmlAssetById("ui_element").xml;
    private var uiElement: GUIElement;


    public function new() {
        uiElement = new GUIElement();
        uiElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(uiXml.toString());
    }

    public function getGuiElement(): GUIElement {
        return  uiElement;
    }

}
