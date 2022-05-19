package com.dinox.model;
import com.genome2d.input.GMouseInputType;
import com.genome2d.tilemap.GTile;
import com.dinox.view.TileRenderer;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.tilemap.GTileMap;
import com.dinox.view.InfoPopupElement;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenStep;
import com.dinox.view.MainMapScreen;
import com.genome2d.macros.MGDebug;
import com.genome2d.input.GMouseInput;
import com.genome2d.debug.GDebug;
class LandMap {
    private static var MAX_SCALE: Float = 2;
    private static var MIN_SCALE: Float = 0.2;

//    public static var TILE_COUNT: Int = 16; // real tile count is TILE_COUNT x TILE_COUNT
    public static var TILE_COUNT: Int = 256; // real tile count is TILE_COUNT x TILE_COUNT

    private var mainMapScreen: MainMapScreen;

    private var canChangeZoom: Bool = true;
    private var canHideInfoPopup: Bool = true;
    private var isDragging: Bool = false;
    private var lastX: Float;
    private var lastY: Float;
    private var mapDistanceDragged: Float = 0;
    private var core: Core;
    private var openInfoPopup: InfoPopupElement = null;

    private var uiGui: GUI;
    private var mapGui: GUI;

    private var tiles: Array<Array<Tile>>;
    private var gtiles: Array<Tile>;

    private var selectedFilters: Array<String> = new Array<String>();

    private var gtileMap: GTileMap;

    public function new(p_uiGui: GUI, p_mapGui: GUI, p_core: Core) {
        core = p_core;
        uiGui = p_uiGui;
        mapGui = p_mapGui;
        mainMapScreen = new MainMapScreen(uiGui, mapGui);
        addUiFilterListeners();
//        addMainMapScreenListeners();
//        gtiles = mainMapScreen.setupTiles();
        gtiles = setupGTiles();
        gtileMap = cast(GNode.createWithComponent(GTileMap), GTileMap);
        gtileMap.setTiles(TILE_COUNT, TILE_COUNT, TileRenderer.BASE_TILE_SIZE, TileRenderer.BASE_TILE_SIZE, cast gtiles);
        mapGui.node.addChild(gtileMap.node);
        addMainGMapScreenListeners();

//        setupTileGroup(3,3,6);
    }

    private function addMainGMapScreenListeners(): Void {
        core.getMapCamera().onMouseInput.add(handleMapCameraMouseInput);
//        core.getMapCamera().onMouseInput.add(handleMapCameraMouseInput);
    }

    private function handleMapCameraMouseInput(p_input: GMouseInput):Void {

        switch(p_input.type) {
            case GMouseInputType.MOUSE_WHEEL:
                mouseWheel_handler(p_input);
            case GMouseInputType.MOUSE_MOVE:
                mouseMove_handler(p_input);
            case GMouseInputType.MOUSE_OVER:
//                mouseOver_handler(p_input);
            case GMouseInputType.MOUSE_OUT:
//                mouseOut_handler(p_input);
            case GMouseInputType.MOUSE_DOWN:
                mouseDown_handler(p_input);
            case GMouseInputType.MOUSE_UP:
                mouseUp_handler(p_input);
            case GMouseInputType.CLICK:
                mouseClick_handler(p_input);

        }
    }

    public function setupGTiles(): Array<Tile> {
        var tiles = new Array<Tile>();
        var tile: Tile;

        for(i in 0...TILE_COUNT) {
            for(j in 0...LandMap.TILE_COUNT) {
                tile = new Tile(i, j, addRandomRarity(), addRandomSize());
                tiles.push(tile);
            }
        }
        return  tiles;
    }

    //TMP
    private function addRandomRarity(): String {
        var rnd: Float = Math.random();
        if(rnd < 0.5) return TileRarityType.COMMON;
        if(rnd < 0.7) return TileRarityType.UNCOMMON;
        if(rnd < 0.8) return TileRarityType.RARE;
        if(rnd < 0.9) return TileRarityType.LEGENDARY;
        return TileRarityType.MYTHICAL;
    }

    private function addRandomSize(): String {
        var rnd: Float = Math.random();
        if(rnd < 0.5) return LandSizeType.ONEXONE;
        if(rnd < 0.75) return LandSizeType.TWOXTWO;
        if(rnd < 0.9) return LandSizeType.THREEXTHREE;
        return LandSizeType.FOURXFOUR;
    }
    //TMP

    private function addUiFilterListeners(): Void {
        mainMapScreen.addSizeFilterListener(sizeFilterClicked_handler);
        mainMapScreen.addRarityFilterListener(rarityFilterClicked_handler);
    }

    public function setupTileGroup(p_i: Int, p_j: Int, p_size: Int): TileGroup {
        if(p_i + p_size <= LandMap.TILE_COUNT &&
        p_j + p_size <= LandMap.TILE_COUNT) {
            var canAddTileGroup: Bool = true;
            var tilesForGroup: Array<Tile> = new Array<Tile>();
            for(i in p_i...p_size-1) {
                for(j in p_j...p_size-1) {
                    if(tiles[i][j].tileIsInGroup) {
                        canAddTileGroup = false;
                    }
                }
            }
            if(canAddTileGroup) {
                var dataToPropagate: String  = cast tiles[p_i][p_j].getTileElement().userData;
                for(i in p_i...p_size-1) {
                    for(j in p_j...p_size-1) {
                        tiles[i][j].tileIsInGroup = true;
                        tiles[i][j].getTileElement().userData = cast dataToPropagate;
                        tilesForGroup.push(tiles[i][j]);
                    }
                }
                var res: TileGroup = new TileGroup(tilesForGroup);
                return res;
            }
        }
        return null;
    }


    private function mouseClick_handler(signal: GMouseInput): Void {

    }

    /**
        Mouse over handler
     **/
    private function mouseOver_handler(signal: GMouseInput): Void {

    }

    /**
        Mouse out handler
     **/
    private function mouseOut_handler(signal: GMouseInput): Void {

    }

    /**
        Mouse down handler
     **/
    private function mouseDown_handler(signal: GMouseInput): Void {
//        MGDebug.INFO(Std.string(signal));
//        var x: Float = core.getMapCamera().node.x;
            var x: Float = signal.contextX;
//        var y: Float = core.getMapCamera().node.y;
            var y: Float = signal.contextY;

        lastX = x;
        lastY = y;
        isDragging = true;
        if(mapDistanceDragged >= 20) {
            closeInfoPopup(false);
        }
    }

    /**
        Mouse up handler
     **/
    private function mouseUp_handler(signal: GMouseInput): Void {
        isDragging = false;
        if(mapDistanceDragged < 20) {
            closeInfoPopup(true, signal.contextX, signal.contextY);
        }
//        var target:GUIElement = cast(signal.target, GUIElement);
        GDebug.info("view rect x: " + Std.string(core.getMapCamera().node.x),"view rect y: " + Std.string(core.getMapCamera().node.y));


        mapDistanceDragged = 0;
    }

    /**
        Mouse wheel handler
     **/
    private function mouseWheel_handler(signal: GMouseInput): Void {
        GDebug.info(Std.string(signal));
//        var target:GUIElement = cast(signal.target, GUIElement);
        var change: Float = signal.delta/15;
        if(canChangeZoom) {
            if(core.getMapCamera().zoom + change < MAX_SCALE &&
                core.getMapCamera().zoom + change > MIN_SCALE) {
                canChangeZoom = false;
                var changedScale: Float = core.getMapCamera().zoom + change;
                var step: GTweenStep = GTween.create(core.getMapCamera(), true).ease(GLinear.none).propF("zoom", core.getMapCamera().zoom + change, 0.1, false).onComplete(onCompleteZoom, [changedScale]);
            }
        }
    }


    private function onCompleteZoom(scaleAfterChange: Float):Void {
        zoomChanged(scaleAfterChange);
        GDebug.info("scaleAfterChange: " + Std.string(scaleAfterChange + " zoom: " + Std.string(core.getMapCamera().zoom)));
        canChangeZoom = true;
    }

    private function onCompleteShowInfoPopup(): Void {
        GDebug.info();
        canHideInfoPopup = true;
    }

    private function onCompleteHideInfoPopup(p_openNew: Bool = false, p_x: Float = 0, p_y: Float = 0): Void {
        if(openInfoPopup != null) {
            openInfoPopup.getGuiElement().visible = false;
            uiGui.root.removeChild(openInfoPopup.getGuiElement());
            openInfoPopup.getGuiElement().dispose();
            openInfoPopup = null;
        }
        if(p_openNew) {
            handleInfoPopupOpen(p_x, p_y);
        }
    }

    /**
        Mouse move handler
     **/
    private function mouseMove_handler(signal: GMouseInput): Void {
        if(isDragging){
            var x: Float = signal.contextX;
            var y: Float = signal.contextY;
            handleDragDistance(x, y);
            var deltaX: Float = (lastX - x) / core.getMapCamera().zoom;
            var deltaY: Float = (lastY - y) / core.getMapCamera().zoom;
            lastX = x;
            lastY = y;
            gtileMap.node.setPosition(gtileMap.node.x - deltaX, gtileMap.node.y - deltaY);

            if(mapDistanceDragged > 50) {
                closeInfoPopup(false);
            }
        }
    }

    private function handleDragDistance(p_x: Float, p_y: Float): Void {
        var distance: Float = Math.sqrt(Math.pow(p_x - lastX, 2) + Math.pow(p_y - lastY, 2));
        mapDistanceDragged += distance;
    }

    private function handleInfoPopupOpen(p_x: Float, p_y: Float): Void {
        GDebug.info();
        openInfoPopup = new InfoPopupElement();
//        openInfoPopup.getGuiElement().anchorX = 0;
        openInfoPopup.getGuiElement().anchorX = Main.stageWidth - openInfoPopup.getGuiElement().preferredWidth;
        openInfoPopup.getGuiElement().anchorY = 0;
        uiGui.root.addChild(openInfoPopup.getGuiElement());
        openInfoPopup.getGuiElement().alpha = 0;
        canHideInfoPopup = false;
        var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 1, 0.1, false).onComplete(onCompleteShowInfoPopup);
    }

    private function closeInfoPopup(p_openNewPopup: Bool = false, p_x: Float = 0, p_y: Float = 0): Void {
        if(canHideInfoPopup) {
            if(openInfoPopup != null) {
                var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 0, 0.1, false).onComplete(onCompleteHideInfoPopup, [p_openNewPopup, p_x, p_y]);
            } else {
                if(p_openNewPopup) {
                    handleInfoPopupOpen(p_x, p_y);
                }
            }
        }
    }

    private function sizeFilterClicked_handler(signal: GMouseInput): Void {
        var target: GUIElement = cast signal.target;
        GDebug.info(target.name);
        handleFilterClick(target.name);
    }

    private function rarityFilterClicked_handler(signal: GMouseInput): Void {
        var target: GUIElement = cast signal.target;
        GDebug.info(target.name);
        handleFilterClick(target.name);
    }

    private function handleFilterClick(p_target: String): Void {
        // filter is already selected, unselect it
        if(selectedFilters.indexOf(p_target) >= 0) {
            selectedFilters.remove(p_target);
        } else {
        // filter is not yet slected, select it
            selectedFilters.push(p_target);
        }
        invalidateTilesHighlight();
    }

    private function invalidateTilesHighlight(): Void {
        GDebug.info("START ---- " + Std.string(Date.now().toString()));
        for(i in 0...gtiles.length) {
            gtiles[i].handleFilter(selectedFilters);
        }
        GDebug.info("END ---- " + Std.string(Date.now().toString()));
    }

    public function zoomChanged(p_scale: Float): Void {
        GDebug.info("START ---- " + Std.string(Date.now().toString()));
        for(i in 0...gtiles.length) {
            gtiles[i].zoomChanged(p_scale);
        }
        GDebug.info("END ---- " + Std.string(Date.now().toString()));
    }
}
