package com.dinox.view;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.textures.GTextureManager;
import com.genome2d.debug.GDebug;
import com.genome2d.ui.skin.GUISkinManager;
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

    private static var cloudsNumber: Int = 400;


    public function new() {
        cloudsElement = new GUIElement();
        cloudsElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(cloudsXml.toString());
        cloudsElement.alpha = 0;
        elementVisible = false;
        generateCloudElements();
    }

    private function generateCloudElements(): Void {
        var cloud: Cloud;
        var clouds: Array<String> = [cloud1, cloud2, cloud3, cloud4, cloud5, cloud6, cloud7, cloud8, cloud9];
        var cloudElements: Array<GUIElement> = new Array<GUIElement>();
        for(c in clouds) {
            var element: GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(c);
            var texture: GUITextureSkin = new GUITextureSkin(element.name, GTextureManager.getTexture('assets/atlas.png_' + element.name));
            element.skin = texture;
            cloudElements.push(element);
        }
        for(i in 0...cloudsNumber) {
            var element: GUIElement = GPrototypeFactory.createInstance(cloudElements[Std.random(9)].getPrototype());
            cast(element.skin, GUITextureSkin).scaleX = 20;
            cast(element.skin, GUITextureSkin).scaleY = 20;
            cloud = new Cloud(element);
            cloudsElement.addChild(cloud.getElement());
        }
    }
    private function tmp(): Void {
        for(key in GUISkinManager.getAllSkins().keys()) {
            GDebug.info("KEY: " + key  + " VALUE: " + cast(GUISkinManager.getSkin(key), GUISkin).id);
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

    private var cloud1:String = '<element name="cloud1"/>';
    private var cloud2:String = '<element name="cloud2"/>';
    private var cloud3:String = '<element name="cloud3"/>';
    private var cloud4:String = '<element name="cloud4"/>';
    private var cloud5:String = '<element name="cloud5"/>';
    private var cloud6:String = '<element name="cloud6"/>';
    private var cloud7:String = '<element name="cloud7"/>';
    private var cloud8:String = '<element name="cloud8"/>';
    private var cloud9:String = '<element name="cloud9"/>';

}
