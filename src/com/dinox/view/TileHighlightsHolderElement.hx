package com.dinox.view;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.assets.GStaticAssetManager;
class TileHighlightsHolderElement {
    private var uiXml: Xml = GStaticAssetManager.getXmlAssetById("tileHighlightsHolder_element").xml;
    private var tileHighlightsHolderElement: GUIElement;
    public function new() {
        tileHighlightsHolderElement = new GUIElement();
        tileHighlightsHolderElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(uiXml.toString());
        tileHighlightsHolderElement.preferredWidth = Main.stageWidth;
        tileHighlightsHolderElement.getChildByName("elementHolder", true).preferredWidth = Main.stageWidth;
        tileHighlightsHolderElement.preferredHeight = Main.stageHeight;
        tileHighlightsHolderElement.getChildByName("elementHolder", true).preferredHeight = Main.stageHeight;
    }

    public function getGuiElement(): GUIElement {
        return  tileHighlightsHolderElement;
    }
}
