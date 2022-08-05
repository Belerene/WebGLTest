package com.dinox.view;
import com.genome2d.proto.GPrototype;
import com.genome2d.proto.GPrototypeFactory;
import com.dinox.model.LandMap;
import com.dinox.model.Cloud;
import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTween;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class CloudsElement {

    private var cloudsXml: Xml = GStaticAssetManager.getXmlAssetById("clouds_element").xml;
    private var cloudsElement: GUIElement;
    private var elementVisible: Bool = false;

    private static var cloudsNumber: Int = 100;


    public function new() {
        cloudsElement = new GUIElement();
        cloudsElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(cloudsXml.toString());
        cloudsElement.alpha = 0;
        elementVisible = false;
        generateCloudElements();
    }

    private function generateCloudElements(): Void {
        var cloud: Cloud;
        var mapHeight: Int = TileRenderer.BASE_TILE_SIZE * LandMap.TILE_COUNT;
        var clouds: Array<String> = [cloud1, cloud2, cloud3, cloud4, cloud5, cloud6, cloud7, cloud8, cloud9];
        for(i in 0...cloudsNumber) {
            var element: GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(clouds[Std.random(9)].toString());
            cloud = new Cloud(element, (Std.random(mapHeight) - Std.int(mapHeight/2)) - 200, i);
            cloudsElement.addChild(cloud.getElement());
        }
    }

    public function handleZoomChange(p_currentZoom: Float, p_zoomBreakpoint: Float):Void {
        if(p_currentZoom < p_zoomBreakpoint) {
            if(!elementVisible) {
                showElement();
            }
        } else {
            if(elementVisible) {
                hideElement();
            }
        }
    }

    private function showElement(): Void {
        GTween.create(cloudsElement, true).ease(GLinear.none).propF("alpha", 1, 0.1, false);
        elementVisible = true;
    }

    private function hideElement(): Void {
        GTween.create(cloudsElement, true).ease(GLinear.none).propF("alpha", 0, 0.1, false);
        elementVisible = false;
    }

    public function getGuiElement(): GUIElement {
        return  cloudsElement;
    }

    private var cloud1:String = '<element name="cloud1" skin="@cloud1"/>';
    private var cloud2:String = '<element name="cloud2" skin="@cloud2"/>';
    private var cloud3:String = '<element name="cloud3" skin="@cloud3"/>';
    private var cloud4:String = '<element name="cloud4" skin="@cloud4"/>';
    private var cloud5:String = '<element name="cloud5" skin="@cloud5"/>';
    private var cloud6:String = '<element name="cloud6" skin="@cloud6"/>';
    private var cloud7:String = '<element name="cloud7" skin="@cloud7"/>';
    private var cloud8:String = '<element name="cloud8" skin="@cloud8"/>';
    private var cloud9:String = '<element name="cloud9" skin="@cloud9"/>';

}
