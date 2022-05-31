package com.dinox.model;
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
        GStaticAssetManager.addFromUrl("assets/2048.png", "dinos");
        GStaticAssetManager.addFromUrl("assets/tile_n.png", "tile_n");
        GStaticAssetManager.addFromUrl("assets/tile_l.png", "tile_l");
        GStaticAssetManager.addFromUrl("assets/tile_s.png", "tile_s");
        GStaticAssetManager.addFromUrl("assets/default_s.png", "default_s");
        GStaticAssetManager.addFromUrl("assets/default_n.png", "default_n");
        GStaticAssetManager.addFromUrl("assets/default_l.png", "default_l");
        GStaticAssetManager.addFromUrl("assets/ui.png", "ui");
        GStaticAssetManager.addFromUrl("assets/dev.png", "dev");
        GStaticAssetManager.addFromUrl("assets/dev_black.png", "dev_black");
        GStaticAssetManager.addFromUrl("assets/separator_h_common.png", "separator_h_common");
        GStaticAssetManager.addFromUrl("assets/separator_h_uncommon.png", "separator_h_uncommon");
        GStaticAssetManager.addFromUrl("assets/separator_h_rare.png", "separator_h_rare");
        GStaticAssetManager.addFromUrl("assets/separator_h_legendary.png", "separator_h_legendary");
        GStaticAssetManager.addFromUrl("assets/separator_h_mythical.png", "separator_h_mythical");
        GStaticAssetManager.addFromUrl("assets/separator_v_common.png", "separator_v_common");
        GStaticAssetManager.addFromUrl("assets/separator_v_uncommon.png", "separator_v_uncommon");
        GStaticAssetManager.addFromUrl("assets/separator_v_rare.png", "separator_v_rare");
        GStaticAssetManager.addFromUrl("assets/separator_v_legendary.png", "separator_v_legendary");
        GStaticAssetManager.addFromUrl("assets/separator_v_mythical.png", "separator_v_mythical");

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
        GStaticAssetManager.addFromUrl("assets/prototypes/tile_prototype.xml", "tile");
        GStaticAssetManager.addFromUrl("assets/prototypes/info_popup_prototype.xml", "popup_element");
        GStaticAssetManager.addFromUrl("assets/skin_sheet.xml", "skin_sheet");
    }

    private function assetsLoaded(): Void {
        // create textures to be later used from loaded assets
        GStaticAssetManager.generate();

        // create fonts
        GFontManager.createTextureFont("font_fnt", GTextureManager.getTexture("font_png"), GStaticAssetManager.getXmlAssetById("font_fnt").xml);
        GFontManager.createTextureFont("font_normal", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
        GFontManager.createTextureFont("font_semibold", GTextureManager.getTexture("font_semibold_png"), GStaticAssetManager.getXmlAssetById("font_semibold").xml);

        // create skins to be used with GUIElements
        var skinSheetXml: Xml = GStaticAssetManager.getXmlAssetById("skin_sheet").xml;
        GXmlPrototypeParser.createPrototypeFromXmlString(skinSheetXml.toString());

        assetsLoaded_handler();
    }

    private function loadAssetsQueue(): Void {
        GStaticAssetManager.loadQueue(assetsLoaded, assetFailed_handler);
    }
}
