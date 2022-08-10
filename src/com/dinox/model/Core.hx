package com.dinox.model;
import js.Syntax;
import haxe.Http;
import haxe.format.JsonParser;
import haxe.Json;
import com.genome2d.debug.GDebug;
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
    private var cloudsGui: GUI;
    private var uiGui: GUI;
    private var tileHighlightGui: GUI;

    private var mapCamera: GCameraController;
    private var uiCamera: GCameraController;
    private var assetsWrapper: AssetsWrapper;
    private var landMap: LandMap;

    public function new(p_root: GNode) {
        rootNode = p_root;
        rootNode.setPosition((Main.stageWidth/2), (Main.stageHeight/2));
        Main.onResizeCallback.add(onResize);

        setupMapGUI();
        setupCloudsGUI();
        setupTileHighlightGUI();
        setupUIGUI();
        initMapCamera();
        initUICamera();

        initAssetsWrapper();

        Syntax.code("window.worldMapInitialized();");

    }

    private function onResize(diffW: Int, diffH: Int): Void {
        rootNode.setPosition((Main.stageWidth/2), (Main.stageHeight/2));
        mapGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        cloudsGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        tileHighlightGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        uiGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
    }

    public function tmpTest(): Void {
        GDebug.info();
        var tmp: LandLoader = new LandLoader(LandLoader.LandJsonPath);
        tmp.addOnStatusReceived();
        tmp.addOnDataReceived(parseJson);
        tmp.addOnErrorReceived();
//        tmp.addOnBytesReceived();
        tmp.makeRequest();
    }

    public function getListOfOwnedLands(): Void {
        var request: Http = new Http("https://api.dinox.io/land/claimable");
        request.onData = parseOwnedLands;
        request.request(false);
    }

    private function parseJson(p_data: String): Void {
        var json: Dynamic  = JsonParser.parse(p_data);
        landMap.addTileGroupsFromJson(json.lands);
    }

    private function parseOwnedLands(p_data: String): Void {
        var json: Dynamic = JsonParser.parse(p_data);
        landMap.addOwnedLands(json.result);
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

    private function setupCloudsGUI(): Void {
        cloudsGui = cast(GNode.createWithComponent(GUI), GUI);
        cloudsGui.node.mouseEnabled = true;
        cloudsGui.root.mouseEnabled = true;
        cloudsGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        cloudsGui.node.cameraGroup = MAP_CAMERA_GROUP;
        rootNode.addChild(cloudsGui.node);
        rootNode.getChildAt(rootNode.getChildIndex(cloudsGui.node)).setPosition(0,0);
    }

    private function setupTileHighlightGUI(): Void {
        tileHighlightGui = cast(GNode.createWithComponent(GUI), GUI);
        tileHighlightGui.node.mouseEnabled = true;
        tileHighlightGui.root.mouseEnabled = true;
        tileHighlightGui.setBounds(new GRectangle(0,0, Main.stageWidth,Main.stageHeight));
        tileHighlightGui.node.cameraGroup = UI_CAMERA_GROUP;
        rootNode.addChild(tileHighlightGui.node);
        rootNode.getChildAt(rootNode.getChildIndex(tileHighlightGui.node)).setPosition(0,0);
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
        mapCamera = cast(GNode.createWithComponent(GCameraController), GCameraController);
        mapCamera.node.setPosition(0, 0);
        mapCamera.node.name = "mapCamera";
        mapCamera.setView(0, 0, 1, 1);
        mapCamera.contextCamera.group = MAP_CAMERA_GROUP;
        mapCamera.zoom = Main.INITIAL_ZOOM;
        rootNode.addChild(mapCamera.node);
    }

    private function initUICamera(): Void {
        uiCamera = cast(GNode.createWithComponent(GCameraController), GCameraController);
        uiCamera.node.setPosition(0, 0);
        uiCamera.node.name = "uiCamera";
        uiCamera.setView(0, 0, 1, 1);
        uiCamera.contextCamera.group = UI_CAMERA_GROUP;
        rootNode.addChild(uiCamera.node);
    }

    private function initAssetsWrapper(): Void {
        assetsWrapper = new AssetsWrapper(assetsLoader_handler, assetsFailed_hanled);
    }

    private function initLandMap(): Void {
        landMap = new LandMap(uiGui, tileHighlightGui, mapGui, cloudsGui, this);
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

    public function getCloudsGUI(): GUI {
        return cloudsGui;
    }

    // HANDLERS //

    private function assetsLoader_handler(): Void {
        initLandMap();
    }

    private function assetsFailed_hanled(p_asset: GAsset): Void {
        MGDebug.ERROR("Core.assetsFailed_hanlder: failed to load asset ", p_asset.id);
    }

}
