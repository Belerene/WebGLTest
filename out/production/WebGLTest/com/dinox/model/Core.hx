package com.dinox.model;
import com.genome2d.components.GCameraController;
import com.genome2d.geom.GRectangle;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.macros.MGDebug;
import com.genome2d.assets.GAsset;
import com.genome2d.node.GNode;
class Core {
    public static var UI_CAMERA_GROUP: Int = 1;
    public static var MAP_CAMERA_GROUP: Int = 2;
    public static var UI_NODE_NAME: String = "ui_node";
    public static var MAP_NODE_NAME: String = "map_node";

    private var rootNode: GNode;
    private var mapNode: GNode;
    private var uiNode: GNode;
    private var mapGui: GUI;
    private var uiGui: GUI;

    private var mapCamera: GCameraController;
    private var uiCamera: GCameraController;
    private var assetsWrapper: AssetsWrapper;
    private var landMap: LandMap;

    public function new(p_root: GNode) {
        rootNode = p_root;
        rootNode.setPosition((Main.stageWidth/2), (Main.stageHeight/2));

        setupMapGUI();
        setupUIGUI();
        initMapCamera();
        initUICamera();

        initAssetsWrapper();
    }


    private function setupMapGUI(): Void {
        mapGui = cast(GNode.createWithComponent(GUI), GUI);
        mapGui.node.mouseEnabled = true;
        mapGui.root.mouseEnabled = true;
        mapGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        mapGui.node.cameraGroup = MAP_CAMERA_GROUP;
        rootNode.addChild(mapGui.node);
        rootNode.getChildAt(rootNode.getChildIndex(mapGui.node)).setPosition(0,0);
    }

    private function setupUIGUI(): Void {
        uiGui = cast(GNode.createWithComponent(GUI), GUI);
        uiGui.node.mouseEnabled = true;
        uiGui.root.mouseEnabled = true;
        uiGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        uiGui.node.cameraGroup = UI_CAMERA_GROUP;
        rootNode.addChild(uiGui.node);
        rootNode.getChildAt(rootNode.getChildIndex(uiGui.node)).setPosition(0,0);
    }

    private function initMapCamera(): Void {
        mapCamera = cast(GNode.createWithComponent(CameraController), CameraController);
        mapCamera.node.setPosition(0, 0);
        mapCamera.contextCamera.group = MAP_CAMERA_GROUP;
        rootNode.addChild(mapCamera.node);
    }

    private function initUICamera(): Void {
        uiCamera = cast(GNode.createWithComponent(CameraController), CameraController);
        uiCamera.node.setPosition(0, 0);
        uiCamera.contextCamera.group = UI_CAMERA_GROUP;
        rootNode.addChild(uiCamera.node);
    }

    private function initAssetsWrapper(): Void {
        assetsWrapper = new AssetsWrapper(assetsLoader_handler, assetsFailed_hanled);
    }

    private function initLandMap(): Void {
        landMap = new LandMap(uiGui, mapGui, this);
    }

    public function getUICamera(): GCameraController {
        return uiCamera;
    }

    public function getMapCamera(): GCameraController {
        return mapCamera;
    }

    public function getMapGUI(): GUI {
        return mapGui;
    }

    // HANDLERS //

    private function assetsLoader_handler(): Void {
        initLandMap();
    }

    private function assetsFailed_hanled(p_asset: GAsset): Void {
        MGDebug.ERROR("Core.assetsFailed_hanlder: failed to load asset ", p_asset.id);
    }

}
