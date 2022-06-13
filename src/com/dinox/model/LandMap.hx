package com.dinox.model;
import haxe.Json;
import com.dinox.controller.MainController;
import com.genome2d.context.GCamera;
import com.dinox.view.TileRenderer;
import com.dinox.model.tile.Land;
import com.dinox.model.tile.TileSizeType;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.Tile;
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


    public static var TILE_COUNT: Int = 300; // real tile count is TILE_COUNT x TILE_COUNT
//    public static var TILE_COUNT: Int = 256; // real tile count is TILE_COUNT x TILE_COUNT

    private var mainMapScreen: MainMapScreen;


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

    private var DEVMoveEnabled: Bool = false;
    private var DEVClickedTile: Tile;

    private var gtileMap: GTileMap;
    private var lands: Array<Land>;
    private var controller: MainController;


    public function new(p_uiGui: GUI, p_mapGui: GUI, p_core: Core) {
        core = p_core;
        uiGui = p_uiGui;
        mapGui = p_mapGui;
        mainMapScreen = new MainMapScreen(uiGui, mapGui);
        filterAsRadioButtons = true;
        setupTiles();
        lands = new Array<Land>();
        gtileMap = cast(GNode.createWithComponent(GTileMap), GTileMap);
        gtileMap.setTiles(TILE_COUNT, TILE_COUNT, TileRenderer.BASE_TILE_SIZE, TileRenderer.BASE_TILE_SIZE, tiles);
        mapGui.node.addChild(gtileMap.node);
        controller = new MainController(p_core);
        controller.addMapScreenListeners(mapDragged_handler, infoPopupOpen_handler, zoomChanged_handler);
        controller.addUiFilterListeners(mainMapScreen.getUiElement().getGuiElement(), sizeFilterClicked_handler, rarityFilterClicked_handler, devUiClicked_handler);

        if(Main.IS_DEV) {
            controller.addDevMapScreenListeners(DEV_mapDragged_handler, DEV_mapMouseDown_handler);
            controller.addDevUIListener(devUiClicked_handler, mainMapScreen.getUiElement().getGuiElement());
        }

        // TMP
        core.tmpTest();

        // TMP
//        setupTileGroup(3,3,4, ["tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile","tile"], TileRarityType.MYTHICAL, 123);
    }

    public function addTileGroupsFromJson(p_json: Dynamic): Void {
        for(field in Reflect.fields(p_json)) {
            var landElement: Dynamic = Reflect.getProperty(p_json, field);
            var assets: String = Std.string(Reflect.getProperty(landElement, "assets"));
            lands.push(setupLand(Reflect.getProperty(landElement, "_id"),
                        Reflect.getProperty(landElement, "x"),
                        Reflect.getProperty(landElement, "y"),
                        Reflect.getProperty(landElement, "size"),
                        Reflect.getProperty(landElement, "rarity"),
                        assets.split(",")));
        }
    }


    public function setupTiles(): Void {
        tiles = new Array<Tile>();
        var tile: Tile;
        for(i in 0...TILE_COUNT) {
            for(j in 0...LandMap.TILE_COUNT) {
                tile = new Tile(j, i, addRandomRarity(), addRandomSize());
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

    private function addRandomSize(): Int {
        var rnd: Float = Math.random();
        if(rnd < 0.5) return TileSizeType.ONEXONE;
        if(rnd < 0.75) return TileSizeType.TWOXTWO;
        if(rnd < 0.9) return TileSizeType.THREEXTHREE;
        return TileSizeType.FOURXFOUR;
    }
    //TMP

    public function setupLand(p_id: Int, p_i: Int, p_j: Int, p_size: Int, p_rarity: String, p_assets: Array<String>): Land {
        if(p_i + p_size <= LandMap.TILE_COUNT &&
            p_j + p_size <= LandMap.TILE_COUNT) {
            var canAddTileGroup: Bool = true;
            var tilesForGroup: Array<Tile> = new Array<Tile>();
            for(i in p_i...p_i+p_size) {
                for(j in p_j...p_j+p_size) {
                    if(tiles[Tile.getIndexFromCoordinates(i, j)].tileIsInLand) {
                        canAddTileGroup = false;
                    }
                    tilesForGroup.push(tiles[Tile.getIndexFromCoordinates(i, j)]);
                }
            }
            if(canAddTileGroup) {
                var res: Land = new Land(p_id, p_i, p_j, p_size, p_rarity, p_assets,tilesForGroup);
                return res;
            } else {
                GDebug.warning("Cannot add land at x: " + Std.string(p_i) + " y: " + Std.string(p_j) + " of size: " + Std.string(p_size) + ", tiles are already in another land!");
            }
        } else {
            GDebug.warning("Cannot add land at x: " + Std.string(p_i) + " y: " + Std.string(p_j) + " of size: " + Std.string(p_size) + ", land would be out of maps bounds!");
        }
        return null;
    }

    private function invalidateTilesHighlight(): Void {
        handleFilterRadioButtons();
        for(i in 0...tiles.length) {
            tiles[i].handleFilter(selectedFilters);
        }
    }

    private function zoomChanged_handler(p_scale: Float): Void {
        for(i in 0...tiles.length) {
            tiles[i].zoomChanged(p_scale);
        }
    }

    private function onCompleteHideInfoPopup(p_openNewPopupAfterClosing: Bool = false, p_tile: Tile = null): Void {
        if(openInfoPopup != null) {
            openInfoPopup.getGuiElement().visible = false;
            controller.removeDevInfoPopupHandlers(openInfoPopup.getGuiElement());
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
            openInfoPopup = new InfoPopupElement(getLandByTile(p_tile));
            openInfoPopup.getGuiElement().anchorX = Main.stageWidth - openInfoPopup.getGuiElement().preferredWidth;
            openInfoPopup.getGuiElement().anchorY = 0;
            openInfoPopup.getGuiElement().getChildByName("infoPopup_closeBtn", true).onMouseUp.add(onCloseInfoPopup_handler);
            uiGui.root.addChild(openInfoPopup.getGuiElement());
            openInfoPopup.getGuiElement().alpha = 0;
            controller.canHideInfoPopup = false;
            if(Main.IS_DEV) {
                controller.addDevInfoPopupHandlers(DEV_infoPopupRarity_handler, DEV_infoPopupSize_handler, DEV_infoPopupAsset_handler, openInfoPopup.getGuiElement());
            }
            var step: GTweenStep = GTween.create(openInfoPopup.getGuiElement(), true).ease(GLinear.none).propF("alpha", 1, 0.1, false).onComplete(controller.onCompleteShowInfoPopup);
        }
    }

    private function handleDevLandMove(p_moveByX: Int, p_moveByY: Int): Void {
        var landToMove: Land = getLandByTile(DEVClickedTile);
        if(landToMove == null) return;
        var tiles: Array<Tile> = landToMove.getTiles();
        var newTiles: Array<Tile> = new Array<Tile>();
        var tile: Tile;
        var defaultTile: Tile;
        for(i in 0...tiles.length) {
            tile = tiles[i];
            newTiles.push(tile);
            defaultTile = new Tile(tile.getGTile().mapX, tile.getGTile().mapY, TileRarityType.COMMON, TileSizeType.ONEXONE);
            gtileMap.setTile(Tile.getIndexFromCoordinates(tile.getGTile().mapX, tile.getGTile().mapY), defaultTile);
            newTiles[i].getGTile().mapX += p_moveByX;
            newTiles[i].getGTile().mapY += p_moveByY;
        }
        for(i in 0...newTiles.length) {
            tile = newTiles[i];
            gtileMap.setTile(Tile.getIndexFromCoordinates(tile.getGTile().mapX, tile.getGTile().mapY), tile);
        }
    }

    private function handleRadiobuttonFilterClick(p_target: String): Void {
        if(p_target == "one" || p_target == "two"
        || p_target == "three" || p_target == "four") {
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

    private function getLandByTile(p_tile: Tile): Land {
        for(i in 0...lands.length) {
            if(lands[i].containsTile(p_tile)) {
                return lands[i];
            }
        }
        return null;
    }

    private function updateLand(p_land: Land, p_gtileMapIsDirty: Bool = false, p_originalSize: Int = 0): Void {
        for(i in 0...lands.length) {
            if(lands[i].getId() == p_land.getId()) {
                if(p_land.getTiles().length != lands[i].getTiles().length){
                    var defaultTile: Tile;
                    for(j in 0...lands[i].getTiles().length) {
                        defaultTile = new Tile(lands[i].getTiles()[j].getGTile().mapX, lands[i].getTiles()[j].getGTile().mapY, TileRarityType.COMMON, lands[i].getSize());
                        gtileMap.setTile(Tile.getIndexFromCoordinates(lands[i].getTiles()[j].getGTile().mapX, lands[i].getTiles()[j].getGTile().mapY), defaultTile);
                    }
                }

                if(p_gtileMapIsDirty) {
                    var land: Land = p_land;
                    var startXIndex: Int = land.getX();
                    var startYIndex: Int = land.getY();
                    var endXIndex: Int = p_land.getX()+ p_land.getSize();
                    var endYIndex: Int = p_land.getY()+ p_land.getSize();
                    var index: Int  = 0;
                    var tile: Tile;
                    for(j in startXIndex...endXIndex) {
                        for(k in startYIndex...endYIndex) {
                            if(land.getTiles()[index] == null) {
                                tile = new Tile(j, k, TileRarityType.COMMON, 1);
                            } else {
                                tile = land.getTiles()[index];
                            }
                            gtileMap.setTile(Tile.getIndexFromCoordinates(j, k), tile);
                            index++;
                        }
                    }
                }
                lands[i] = p_land.clone();
                return;
            }
        }
    }

    /**
    * MOUSE HANDLERS
    **/

    private function infoPopupOpen_handler(p_x: Float, p_y: Float, p_contextCamera: GCamera): Void {
        var tile: Tile = gtileMap.getTileAt(p_x, p_y, p_contextCamera);
        if(tile.tileIsInLand) {
            handleInfoPopupOpen(tile);
        }
    }

    private function mapDragged_handler(p_deltaX: Float, p_deltaY: Float): Void {
        if(DEVMoveEnabled == false) {
            gtileMap.node.setPosition(gtileMap.node.x - p_deltaX, gtileMap.node.y - p_deltaY);
        }
    }

    private function DEV_mapDragged_handler(p_x: Float, p_y: Float, p_contextCamera: GCamera): Void {
        if(DEVMoveEnabled) {
            var tile: Tile = gtileMap.getTileAt(p_x, p_y, p_contextCamera);
            if(tile != DEVClickedTile) {
                handleDevLandMove(tile.getGTile().mapX - DEVClickedTile.getGTile().mapX, tile.getGTile().mapY - DEVClickedTile.getGTile().mapY);
                tile = gtileMap.getTileAt(p_x, p_y, p_contextCamera);
                DEVClickedTile = tile;
            }
        }
    }

    private function DEV_mapMouseDown_handler(p_x: Float, p_y: Float, p_camera: GCamera): Void {
        if(DEVMoveEnabled) {
            DEVClickedTile = gtileMap.getTileAt(p_x, p_y, p_camera);
        }
    }

    private function DEV_infoPopupRarity_handler(signal: GMouseInput): Void {
        var land: Land = openInfoPopup.getLand();
        GDebug.info(cast(signal.target, GUIElement).name);
        switch(cast(signal.target, GUIElement).name) {
            case "info_popup_rarity_l":
                land.setRarity(TileRarityType.lowerRarity(land.getRarity()));
                openInfoPopup.invalidate(land);
            case "info_popup_rarity_r":
                land.setRarity(TileRarityType.higherRarity(land.getRarity()));
                openInfoPopup.invalidate(land);
        }

        updateLand(land);
    }

    private function DEV_infoPopupSize_handler(signal: GMouseInput): Void {
        var land: Land = openInfoPopup.getLand().clone();
        GDebug.info(cast(signal.target, GUIElement).name);
        switch(cast(signal.target, GUIElement).name) {
            case "info_popup_size_l":
                land.setSize(TileSizeType.lowerSize(land.getSize()));
                openInfoPopup.invalidate(land);
            case "info_popup_size_r":
                land.setSize(TileSizeType.higherSize(land.getSize()));
                openInfoPopup.invalidate(land);
        }

        updateLand(land, true);
    }

    private function DEV_infoPopupAsset_handler(signal: GMouseInput): Void {
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

    private function devUiClicked_handler(signal: GMouseInput): Void {
        var target: GUIElement = cast signal.target;
        switch(target.name) {
            case "move_enabled": DEV_moveEnabledToggle();
        }
    }

    private function onCloseInfoPopup_handler(signal: GMouseInput): Void {
        if(controller.canHideInfoPopup) {
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

    private function DEV_moveEnabledToggle(): Void {
        DEVMoveEnabled = !DEVMoveEnabled;
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
