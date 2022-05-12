package com.dinox.view;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class MapElement {

    private var mapXml: Xml = GStaticAssetManager.getXmlAssetById("map_element").xml;
    private var mapElement: GUIElement;


    public function new() {
        mapElement = new GUIElement();
        mapElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(mapXml.toString());
    }

    public function getGuiElement(): GUIElement {
        return  mapElement;
    }

}
