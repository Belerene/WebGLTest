package com.dinox.model;
import com.genome2d.assets.GAssetManager;
import com.genome2d.text.GFontManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.textures.GTextureManager;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GStaticAssetManager;
class AssetsWrapper {
    private var assetsLoaded_handler: Void->Void;
    private var assetFailed_handler: GAsset->Void;

    public function new(p_assetsLoaded_handler: Void->Void, p_assetFailed_handler: GAsset->Void = null) {
        assetsLoaded_handler = p_assetsLoaded_handler;
        assetFailed_handler = p_assetFailed_handler;
        addAssetsFromURL();
        loadAssetsQueue();
    }

    private function addAssetsFromURL(): Void {
        // add more assets here - path + their id

        // ASSETS
        GStaticAssetManager.addFromUrl("assets/atlas.png");
        GStaticAssetManager.addFromUrl("assets/atlas.xml");
//
        // ASSETS THAT NEED TO BE AVAILABLE ON START OF APP (UI/DEV ELEMENTS)
        GStaticAssetManager.addFromUrl("assets/ui.png", "ui");
        GStaticAssetManager.addFromUrl("assets/dev.png", "dev");
        GStaticAssetManager.addFromUrl("assets/dev_black.png", "dev_black");
        GStaticAssetManager.addFromUrl("assets/checkbox.png", "checkbox");
        GStaticAssetManager.addFromUrl("assets/noise.png", "noise");
        GStaticAssetManager.addFromUrl("assets/ocean.png", "ocean");
        GStaticAssetManager.addFromUrl("assets/checkbox_checked.png", "checkbox_checked");
        GStaticAssetManager.addFromUrl("assets/icon_close.png", "icon_close");
        GStaticAssetManager.addFromUrl("assets/semitransparent_bg.png", "semitransparent_bg");
//        GStaticAssetManager.addFromUrl("assets/hover_60.png", "hover_60");
        GStaticAssetManager.addFromUrl("assets/hover9s.png", "hover9s");
        GStaticAssetManager.addFromUrl("assets/cloud1.png", "cloud1");
        GStaticAssetManager.addFromUrl("assets/cloud2.png", "cloud2");
        GStaticAssetManager.addFromUrl("assets/cloud3.png", "cloud3");
        GStaticAssetManager.addFromUrl("assets/cloud4.png", "cloud4");
        GStaticAssetManager.addFromUrl("assets/cloud5.png", "cloud5");
        GStaticAssetManager.addFromUrl("assets/cloud6.png", "cloud6");
        GStaticAssetManager.addFromUrl("assets/cloud7.png", "cloud7");
        GStaticAssetManager.addFromUrl("assets/cloud8.png", "cloud8");
        GStaticAssetManager.addFromUrl("assets/cloud9.png", "cloud9");

        // FONTS
        GStaticAssetManager.addFromUrl("assets/fonts/font.png", "font_png");
        GStaticAssetManager.addFromUrl("assets/fonts/font.fnt", "font_fnt");
        GStaticAssetManager.addFromUrl("assets/fonts/chopin_medium.fnt", "font_normal");
        GStaticAssetManager.addFromUrl("assets/fonts/chopin_medium.png", "font_normal_png");
        GStaticAssetManager.addFromUrl("assets/fonts/chopin_semibold.fnt", "font_semibold");
        GStaticAssetManager.addFromUrl("assets/fonts/chopin_semibold.png", "font_semibold_png");

        // PROTOTYPES
        GStaticAssetManager.addFromUrl("assets/prototypes/main_ui_prototype.xml", "ui_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/map_prototype.xml", "map_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/clouds_prototype.xml", "clouds_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/tile_prototype.xml", "tile");
        GStaticAssetManager.addFromUrl("assets/prototypes/info_popup_prototype.xml", "popup_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/tile_mouseover_holder_prototype.xml", "tileHighlightsHolder_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/tile_mouseover_element_prototype.xml", "tileMouseOver_element");
        GStaticAssetManager.addFromUrl("assets/skin_sheet.xml", "skin_sheet");
    }

    private function assetsLoaded(): Void {
        // create textures to be later used from loaded assets
        GStaticAssetManager.generate();

        // create fonts
        GFontManager.createTextureFont("font_fnt", GTextureManager.getTexture("font_png"), GStaticAssetManager.getXmlAssetById("font_fnt").xml);
        GFontManager.createTextureFont("font_normal", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
        GFontManager.createTextureFont("font_smaller", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
        GFontManager.createTextureFont("font_semibold", GTextureManager.getTexture("font_semibold_png"), GStaticAssetManager.getXmlAssetById("font_semibold").xml);

        // create skins to be used with GUIElements
        var skinSheetXml: Xml = GStaticAssetManager.getXmlAssetById("skin_sheet").xml;
        GXmlPrototypeParser.createPrototypeFromXmlString(skinSheetXml.toString());

//        GFontManager.getFont("font_smaller").
        assetsLoaded_handler();
    }

    private function loadAssetsQueue(): Void {
        GStaticAssetManager.loadQueue(assetsLoaded, assetFailed_handler);
    }
}
