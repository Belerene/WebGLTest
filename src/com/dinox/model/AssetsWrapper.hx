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
//        GStaticAssetManager.addFromUrl("assets/tile_n.png", "tile_n");
//        GStaticAssetManager.addFromUrl("assets/tile_l.png", "tile_l");
//        GStaticAssetManager.addFromUrl("assets/tile_s.png", "tile_s");
//        GStaticAssetManager.addFromUrl("assets/tile_1_n.png", "tile_1_n");
//        GStaticAssetManager.addFromUrl("assets/tile_2_n.png", "tile_2_n");
//        GStaticAssetManager.addFromUrl("assets/tile_3_n.png", "tile_3_n");
//        GStaticAssetManager.addFromUrl("assets/tile_4_n.png", "tile_4_n");
//        GStaticAssetManager.addFromUrl("assets/tile_5_n.png", "tile_5_n");
//        GStaticAssetManager.addFromUrl("assets/tile_6_n.png", "tile_6_n");
//        GStaticAssetManager.addFromUrl("assets/tile_7_n.png", "tile_7_n");
//        GStaticAssetManager.addFromUrl("assets/tile_8_n.png", "tile_8_n");
//        GStaticAssetManager.addFromUrl("assets/tile_9_n.png", "tile_9_n");
//        GStaticAssetManager.addFromUrl("assets/tile_1_l.png", "tile_1_l");
//        GStaticAssetManager.addFromUrl("assets/tile_2_l.png", "tile_2_l");
//        GStaticAssetManager.addFromUrl("assets/tile_3_l.png", "tile_3_l");
//        GStaticAssetManager.addFromUrl("assets/tile_4_l.png", "tile_4_l");
//        GStaticAssetManager.addFromUrl("assets/tile_5_l.png", "tile_5_l");
//        GStaticAssetManager.addFromUrl("assets/tile_6_l.png", "tile_6_l");
//        GStaticAssetManager.addFromUrl("assets/tile_7_l.png", "tile_7_l");
//        GStaticAssetManager.addFromUrl("assets/tile_8_l.png", "tile_8_l");
//        GStaticAssetManager.addFromUrl("assets/tile_9_l.png", "tile_9_l");
//        GStaticAssetManager.addFromUrl("assets/tile_1_s.png", "tile_1_s");
//        GStaticAssetManager.addFromUrl("assets/tile_2_s.png", "tile_2_s");
//        GStaticAssetManager.addFromUrl("assets/tile_3_s.png", "tile_3_s");
//        GStaticAssetManager.addFromUrl("assets/tile_4_s.png", "tile_4_s");
//        GStaticAssetManager.addFromUrl("assets/tile_5_s.png", "tile_5_s");
//        GStaticAssetManager.addFromUrl("assets/tile_6_s.png", "tile_6_s");
//        GStaticAssetManager.addFromUrl("assets/tile_7_s.png", "tile_7_s");
//        GStaticAssetManager.addFromUrl("assets/tile_8_s.png", "tile_8_s");
//        GStaticAssetManager.addFromUrl("assets/tile_9_s.png", "tile_9_s");
//        GStaticAssetManager.addFromUrl("assets/default_s.png", "default_s");
//        GStaticAssetManager.addFromUrl("assets/default_n.png", "default_n");
//        GStaticAssetManager.addFromUrl("assets/default_l.png", "default_l");
//        GStaticAssetManager.addFromUrl("assets/default_l_1.png", "default_l_1");
//        GStaticAssetManager.addFromUrl("assets/default_l_2.png", "default_l_2");
//        GStaticAssetManager.addFromUrl("assets/default_l_3.png", "default_l_3");
//        GStaticAssetManager.addFromUrl("assets/default_l_4.png", "default_l_4");
//        GStaticAssetManager.addFromUrl("assets/default_l_5.png", "default_l_5");
//        GStaticAssetManager.addFromUrl("assets/ui.png", "ui");
//        GStaticAssetManager.addFromUrl("assets/dev.png", "dev");
//        GStaticAssetManager.addFromUrl("assets/dev_black.png", "dev_black");
//        GStaticAssetManager.addFromUrl("assets/separator_common_nesw.png", "separator_common_nesw");
//        GStaticAssetManager.addFromUrl("assets/separator_uncommon_es.png", "separator_uncommon_es");
//        GStaticAssetManager.addFromUrl("assets/separator_uncommon_ne.png", "separator_uncommon_ne");
//        GStaticAssetManager.addFromUrl("assets/separator_uncommon_nesw.png", "separator_uncommon_nesw");
//        GStaticAssetManager.addFromUrl("assets/separator_uncommon_sw.png", "separator_uncommon_sw");
//        GStaticAssetManager.addFromUrl("assets/separator_uncommon_wn.png", "separator_uncommon_wn");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_e.png", "separator_legendary_e");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_es.png", "separator_legendary_es");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_n.png", "separator_legendary_n");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_ne.png", "separator_legendary_ne");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_s.png", "separator_legendary_s");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_sw.png", "separator_legendary_sw");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_w.png", "separator_legendary_w");
//        GStaticAssetManager.addFromUrl("assets/separator_legendary_wn.png", "separator_legendary_wn");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_e.png", "separator_mythical_e");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_es.png", "separator_mythical_es");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_n.png", "separator_mythical_n");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_ne.png", "separator_mythical_ne");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_s.png", "separator_mythical_s");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_sw.png", "separator_mythical_sw");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_w.png", "separator_mythical_w");
//        GStaticAssetManager.addFromUrl("assets/separator_mythical_wn.png", "separator_mythical_wn");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_e.png", "separator_rare_e");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_es.png", "separator_rare_es");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_n.png", "separator_rare_n");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_ne.png", "separator_rare_ne");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_s.png", "separator_rare_s");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_sw.png", "separator_rare_sw");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_w.png", "separator_rare_w");
//        GStaticAssetManager.addFromUrl("assets/separator_rare_wn.png", "separator_rare_wn");
//        GStaticAssetManager.addFromUrl("assets/checkbox.png", "checkbox");
//        GStaticAssetManager.addFromUrl("assets/checkbox_checked.png", "checkbox_checked");
//        GStaticAssetManager.addFromUrl("assets/icon_close.png", "icon_close");
//        GStaticAssetManager.addFromUrl("assets/semitransparent_bg.png", "semitransparent_bg");

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
        GFontManager.createTextureFont("font_smaller", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
//        GFontManager.createTextureFont("font_normal_common", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
//        GFontManager.createTextureFont("font_normal_uncommon", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
//        GFontManager.createTextureFont("font_normal_rare", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
//        GFontManager.createTextureFont("font_normal_legendary", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
//        GFontManager.createTextureFont("font_normal_mythical", GTextureManager.getTexture("font_normal_png"), GStaticAssetManager.getXmlAssetById("font_normal").xml);
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
