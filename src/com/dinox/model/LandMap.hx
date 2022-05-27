package com.dinox.model;
import com.dinox.view.TileRenderer;
import com.dinox.model.tile.TileGroup;
import com.dinox.model.tile.TileSizeType;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.Tile;
import com.genome2d.input.GMouseInputType;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.tilemap.GTileMap;
import com.dinox.view.InfoPopupElement;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenStep;
import com.dinox.view.MainMapScreen;
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

    private var tiles: Array<Tile>;

    // when filter is used as checkboxes
    private var selectedFilters: Array<String> = new Array<String>();
    // when filter is used as radiobutton
    private var rarityFilterSelected: String = "";
    private var sizeFilterSelected: String = "";
    private var filterAsRadioButtons: Bool = false;

    private var gtileMap: GTileMap;

    public function new(p_uiGui: GUI, p_mapGui: GUI, p_core: Core) {
        core = p_core;
        uiGui = p_uiGui;
        mapGui = p_mapGui;
        mainMapScreen = new MainMapScreen(uiGui, mapGui);
        filterAsRadioButtons = true;
        addUiFilterListeners();
        setupTiles();
        gtileMap = cast(GNode.createWithComponent(GTileMap), GTileMap);
        gtileMap.setTiles(TILE_COUNT, TILE_COUNT, TileRenderer.BASE_TILE_SIZE, TileRenderer.BASE_TILE_SIZE, tiles);
        mapGui.node.addChild(gtileMap.node);
        addMainGMapScreenListeners();

        // TMP
        setupTileGroup(3,3,6);
    }

    private function addMainGMapScreenListeners(): Void {
        core.getMapCamera().onMouseInput.add(handleMapCameraMouseInput);
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

    public function setupTiles(): Void {
        tiles = new Array<Tile>();
        var tile: Tile;
        for(i in 0...TILE_COUNT) {
            for(j in 0...LandMap.TILE_COUNT) {
                tile = new Tile(j, i, addRandomRarity(), addRandomSize(), mapGui.node);
                tiles.push(tile);
            }
        }
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
        if(rnd < 0.5) return TileSizeType.ONEXONE;
        if(rnd < 0.75) return TileSizeType.TWOXTWO;
        if(rnd < 0.9) return TileSizeType.THREEXTHREE;
        return TileSizeType.FOURXFOUR;
    }
    //TMP

    private function addUiFilterListeners(): Void {
        mainMapScreen.addSizeFilterListener(sizeFilterClicked_handler);
        mainMapScreen.addRarityFilterListener(rarityFilterClicked_handler);
    }

    public function setupTileGroup(p_i: Int, p_j: Int, p_size: Int): TileGroup {
        GDebug.info(Tile.getIndexFromCoordinates(p_i, p_j), "i: " + p_i, "j: " + p_j, "size: " + p_size, "tiles: " + tiles.length);
        if(p_i + p_size <= LandMap.TILE_COUNT &&
            p_j + p_size <= LandMap.TILE_COUNT) {
            var canAddTileGroup: Bool = true;
            var tilesForGroup: Array<Tile> = new Array<Tile>();
            for(i in p_i...p_i+p_size-1) {
                for(j in p_j...p_j+p_size-1) {
                    if(tiles[Tile.getIndexFromCoordinates(i, j)].tileIsInGroup) {
                        canAddTileGroup = false;
                    }
                }
            }
            if(canAddTileGroup) {
                var dataToPropagate: String  = cast tiles[p_j*LandMap.TILE_COUNT+p_i].userData;
                var index: Int;
                for(i in p_i...p_i+p_size-1) {
                    for(j in p_j...p_j+p_size-1) {
                        index = Tile.getIndexFromCoordinates(i, j);
                        tiles[index].tileIsInGroup = true;
                        tiles[index].userData = cast dataToPropagate;
                        tilesForGroup.push(tiles[index]);
                        if(i == p_i) {
                            tiles[index].addTopSeparator();
                        }
                        if(i == p_i+p_size-2) {
                            tiles[index].addBottomSeparator();
                        }
                        if(j == p_j) {
                            tiles[index].addLeftSeparator();
                        }
                        if(j == p_j+p_size-2) {
                            tiles[index].addRightSeparator();
                        }
                    }
                }
                var res: TileGroup = new TileGroup(tilesForGroup);
                return res;
            }
        }
        return null;
    }

    private function invalidateTilesHighlight(): Void {
        handleFilterRadioButtons();
        for(i in 0...tiles.length) {
            tiles[i].handleFilter(selectedFilters);
        }
    }

    public function zoomChanged(p_scale: Float): Void {
        for(i in 0...tiles.length) {
            tiles[i].zoomChanged(p_scale);
        }
    }

    private function onCompleteZoom(scaleAfterChange: Float):Void {
        zoomChanged(scaleAfterChange);
        canChangeZoom = true;
    }

    private function handleDragDistance(p_x: Float, p_y: Float): Void {
        var distance: Float = Math.sqrt(Math.pow(p_x - lastX, 2) + Math.pow(p_y - lastY, 2));
        mapDistanceDragged += distance;
    }

    private function onCompleteShowInfoPopup(): Void {
        canHideInfoPopup = true;
    }

    private function onCompleteHideInfoPopup(p_openNewPopupAfterClosing: Bool = false, p_tile: Tile = null): Void {
        if(openInfoPopup != null) {
            openInfoPopup.getGuiElement().visible = false;
            uiGui.root.removeChild(openInfoPopup.getGuiElement());
            openInfoPopup.getGuiElement().dispose();
            openInfoPopup = null;
        }
        if(p_openNewPopupAfterClosing) {
            handleInfoPopupOpen(p_tile);
        }
    }

    private function handleInfoPopupOpen(p_tile: Tile): Void {
        if(p_tile == null) return;
        if(openInfoPopup != null) {
            // infoPopup already open, close it first!
            var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 0, 0.1, false).onComplete(onCompleteHideInfoPopup, [true, p_tile]);
        } else {
            openInfoPopup = new InfoPopupElement(p_tile.userData);
            openInfoPopup.getGuiElement().anchorX = Main.stageWidth - openInfoPopup.getGuiElement().preferredWidth;
            openInfoPopup.getGuiElement().anchorY = 0;
            openInfoPopup.getGuiElement().getChildByName("infoPopup_closeBtn", true).onMouseUp.add(onCloseInfoPopup_handler);
            uiGui.root.addChild(openInfoPopup.getGuiElement());
            openInfoPopup.getGuiElement().alpha = 0;
            canHideInfoPopup = false;
            var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 1, 0.1, false).onComplete(onCompleteShowInfoPopup);
        }
    }

    private function closeInfoPopup(p_openNewPopup: Bool = false, p_tile: Tile = null, p_x: Float = 0, p_y: Float = 0): Void {

    }

    private function handleRadiobuttonFilterClick(p_target: String): Void {
        if(p_target == TileSizeType.ONEXONE || p_target == TileSizeType.TWOXTWO
        || p_target == TileSizeType.THREEXTHREE || p_target == TileSizeType.FOURXFOUR) {
            if(sizeFilterSelected == p_target) {
                // size filter is already selected, unselect it
                sizeFilterSelected = "";
            } else {
                // size filter is not yet slected, select it
                sizeFilterSelected = p_target;
            }
        } else {
            if(rarityFilterSelected == p_target) {
                // rarity filter is already selected, unselect it
                rarityFilterSelected = "";
            } else {
                // rarity filter is not yet slected, select it
                rarityFilterSelected = p_target;
            }
        }
    }

    private function handleFilterRadioButtons(): Void {
        if(filterAsRadioButtons) {
            selectedFilters = new Array<String>();
            if(rarityFilterSelected != "") {
                selectedFilters.push(rarityFilterSelected);
            }
            if(sizeFilterSelected != "") {
                selectedFilters.push(sizeFilterSelected);
            }
        }
    }

    /**
    * MOUSE HANDLERS
    **/

    private function mouseClick_handler(signal: GMouseInput): Void {

    }

    private function mouseOver_handler(signal: GMouseInput): Void {

    }

    private function mouseOut_handler(signal: GMouseInput): Void {

    }

    private function mouseDown_handler(signal: GMouseInput): Void {
        var x: Float = signal.contextX;
        var y: Float = signal.contextY;

        lastX = x;
        lastY = y;

        isDragging = true;
    }

    private function mouseUp_handler(signal: GMouseInput): Void {
        isDragging = false;
        if(mapDistanceDragged < 20) {
            var x: Float = signal.worldX;
            var y: Float = signal.worldY;
            var tile: Tile = gtileMap.getTileAt(x,y, signal.camera.contextCamera);
            handleInfoPopupOpen(tile);
        }
        mapDistanceDragged = 0;
    }

    private function mouseWheel_handler(signal: GMouseInput): Void {
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

    private function onCloseInfoPopup_handler(signal: GMouseInput): Void {
        if(canHideInfoPopup) {
            if(openInfoPopup != null) {
                var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 0, 0.1, false).onComplete(onCompleteHideInfoPopup);
            }
        }
    }

    private function handleFilterClick(p_target: String): Void {
        if(filterAsRadioButtons) {
            handleRadiobuttonFilterClick(p_target);
        } else {
            handleCheckboxFilterClick(p_target);
        }
        invalidateTilesHighlight();
    }

    private function handleCheckboxFilterClick(p_target: String): Void {
        // filter is already selected, unselect it
        if(selectedFilters.indexOf(p_target) >= 0) {
            selectedFilters.remove(p_target);
        } else {
            // filter is not yet slected, select it
            selectedFilters.push(p_target);
        }
    }
}
