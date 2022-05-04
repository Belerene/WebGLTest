package com.dinox.model;
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

        GStaticAssetManager.addFromUrl("assets/2048.png", "dinos");
    }

    private function loadAssetsQueue(): Void {
        GStaticAssetManager.loadQueue(assetsLoaded, assetFailed_handler);
    }

    private function assetsLoaded(): Void {
        // create textures to be later used from loaded assets

        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("dinos").id, cast GStaticAssetManager.getImageAssetById("dinos"));

        assetsLoaded_handler();
    }
}
