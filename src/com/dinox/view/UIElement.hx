package com.dinox.view;
import com.dinox.model.tile.TileRarityType;
import com.genome2d.text.GFont;
import com.genome2d.text.GTextFormat;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.debug.GDebug;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class UIElement {

    private var uiXml: Xml = GStaticAssetManager.getXmlAssetById("ui_element").xml;
    private var uiElement: GUIElement;


    public function new() {
        uiElement = new GUIElement();
        uiElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(uiXml.toString());
        uiElement.preferredWidth = Main.stageWidth;
        uiElement.getChildByName("ui", true).preferredWidth = Main.stageWidth;
        uiElement.preferredHeight = Main.stageHeight;
        uiElement.getChildByName("ui", true).preferredHeight = Main.stageHeight;

        GDebug.info("SETTING COLOR TO LABEL!");
        uiElement.getChildByName("common_label", true).skin.color = TileRarityType.COMMON_COLOR;
        uiElement.getChildByName("uncommon_label", true).skin.color = TileRarityType.UNCOMMON_COLOR;
        uiElement.getChildByName("rare_label", true).skin.color = TileRarityType.RARE_COLOR;
        uiElement.getChildByName("legendary_label", true).skin.color = TileRarityType.LEGENDARY_COLOR;
        uiElement.getChildByName("mythical_label", true).skin.color = TileRarityType.MYTHICAL_COLOR;

        if(Main.IS_DEV) uiElement.setState("dev");

        Main.onResizeCallback.add(onResize);
    }

    public function getGuiElement(): GUIElement {
        return  uiElement;
    }

    private function onResize(diffW: Int, diffH: Int): Void {
        uiElement.preferredWidth = Main.stageWidth;
        uiElement.getChildByName("ui", true).preferredWidth = Main.stageWidth;
        uiElement.preferredHeight = Main.stageHeight;
        uiElement.getChildByName("ui", true).preferredHeight = Main.stageHeight;
    }

}
