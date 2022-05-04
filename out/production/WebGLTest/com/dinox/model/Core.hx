package com.dinox.model;
import js.Browser;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.macros.MGDebug;
import com.genome2d.assets.GAsset;
import com.genome2d.node.GNode;
class Core {
    private var rootNode: GNode;
    private var container: GNode;

    private var cameraController: CameraController;
    private var assetsWrapper: AssetsWrapper;
    private var landMap: LandMap;

    public function new(p_root: GNode) {
        rootNode = p_root;
        initContainer();
        initCameraController();

        initAssetsWrapper();
    }

    private function initContainer(): Void {
        container = new GNode();
        container.cameraGroup = 1;
        rootNode.addChild(container);
    }

    private function initCameraController(): Void {
        cameraController = cast(GNode.createWithComponent(CameraController), CameraController);
        cameraController.node.setPosition(400, 300);
        cameraController.contextCamera.group = 1;
        rootNode.addChild(cameraController.node);
    }

    private function initAssetsWrapper(): Void {
        assetsWrapper = new AssetsWrapper(assetsLoader_handler, assetsFailed_hanled);
    }

    private function initLandMap(): Void {
        landMap = new LandMap(container);
    }

    // GETTERS //
//    public static function getStaticAssetsManager(): GStaticAssetManager {
//        return GStaticAssetManager;
//    }

    public function getContainer(): GNode {
        return container;
    }

    // HANDLERS //

    private function assetsLoader_handler(): Void {
        MGDebug.INFO();
        initLandMap();
    }

    private function assetsFailed_hanled(p_asset: GAsset): Void {
        MGDebug.ERROR("Core.assetsFailed_hanlder: failed to load asset ", p_asset.id);
    }

}
