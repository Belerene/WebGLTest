package com.dinox.view;
import com.genome2d.debug.GDebug;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.dinox.model.tile.Land;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.assets.GStaticAssetManager;
class TileMouseOverElement {

    private var mouseOverXml: Xml = GStaticAssetManager.getXmlAssetById("tileMouseOver_element").xml;
    private var mouseOverElement: GUIElement;
    private var land: Land;

    public function new(p_land: Land) {
        mouseOverElement = new GUIElement();
        mouseOverElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(mouseOverXml.toString());
        invalidate(p_land);
    }

    public function invalidate(p_land: Land): Void {
        land = p_land;
        mouseOverElement.setState(getStringFromSize(land.getSize()));
        hardInvalidateSize();
    }

    private function hardInvalidateSize(): Void {
        // invalidate is not behaving properly during zooming without this
        switch(land.getSize()) {
            case 1:
                mouseOverElement.preferredWidth = 60;
                mouseOverElement.preferredHeight = 60;
                return;
            case 2:
                mouseOverElement.preferredWidth = 120;
                mouseOverElement.preferredHeight = 120;
                return;
            case 3:
                mouseOverElement.preferredWidth = 180;
                mouseOverElement.preferredHeight = 180;
                return;
            case 4:
                mouseOverElement.preferredWidth = 240;
                mouseOverElement.preferredHeight = 240;
                return;
        }
    }

    private function getStringFromSize(p_size: Int): String {
        switch(p_size) {
            case 1: return "one";
            case 2: return "two";
            case 3: return "three";
            case 4: return "four";
            default: return "default";
        }
    }

    public function getGuiElement(): GUIElement {
        return  mouseOverElement;
    }

    public function getLand(): Land {
        return land;
    }
}
