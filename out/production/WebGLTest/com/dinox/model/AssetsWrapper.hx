package com.dinox.model;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.skin.GUISkinManager;
import com.genome2d.debug.GDebug;
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
        GStaticAssetManager.addFromUrl("assets/ui.png", "ui");
        GStaticAssetManager.addFromUrl("assets/dev.png", "dev");


        // PROTOTYPES
        GStaticAssetManager.addFromUrl("assets/prototypes/main_ui_prototype.xml", "ui_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/map_prototype.xml", "map_element");
        GStaticAssetManager.addFromUrl("assets/prototypes/tile_prototype.xml", "tile");
        GStaticAssetManager.addFromUrl("assets/prototypes/info_popup_prototype.xml", "popup_element");
    }

    private function assetsLoaded(): Void {
        // create textures to be later used from loaded assets

        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("dinos").id, cast GStaticAssetManager.getImageAssetById("dinos"));
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("tile_n").id, cast GStaticAssetManager.getImageAssetById("tile_n"));
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("tile_l").id, cast GStaticAssetManager.getImageAssetById("tile_l"));
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("tile_s").id, cast GStaticAssetManager.getImageAssetById("tile_s"));
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("ui").id, cast GStaticAssetManager.getImageAssetById("ui"));
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("dev").id, cast GStaticAssetManager.getImageAssetById("dev"));



        // create skins to be used with GUIElements
        new GUITextureSkin("ui", GTextureManager.getTexture("ui"));
        new GUITextureSkin("tile_n", GTextureManager.getTexture("tile_n"));
        new GUITextureSkin("tile_l", GTextureManager.getTexture("tile_l"));
        new GUITextureSkin("tile_s", GTextureManager.getTexture("tile_s"));
        new GUITextureSkin("dev", GTextureManager.getTexture("dev"));

        assetsLoaded_handler();
    }

    private function loadAssetsQueue(): Void {
        GStaticAssetManager.loadQueue(assetsLoaded, assetFailed_handler);
    }
}
