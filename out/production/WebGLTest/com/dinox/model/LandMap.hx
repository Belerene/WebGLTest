package com.dinox.model;
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
    private static var MIN_SCALE: Float = 0.5;

    public static var TILE_COUNT: Int = 16; // real tile count is TILE_COUNT x TILE_COUNT

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

    public function new(p_uiGui: GUI, p_mapGui: GUI, p_core: Core) {
        core = p_core;
        uiGui = p_uiGui;
        mapGui = p_mapGui;
        mainMapScreen = new MainMapScreen(uiGui, mapGui);
        tiles = mainMapScreen.setupTiles();
        addMainMapScreenListeners();
        setupTileGroup(3,3,6);
    }

    private function addMainMapScreenListeners(): Void {
        addMouseWheelListener(mouseWheel_handler);
        addMouseMoveListener(mouseMove_handler);
        addMouseOverListener(mouseOver_handler);
        addMouseOutListener(mouseOut_handler);
        addMouseDownListener(mouseDown_handler);
        addMouseUpListener(mouseUp_handler);
        addMouseClickListener(mouseClick_handler);
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
        MGDebug.INFO();
        lastX = signal.contextX;
        lastY = signal.contextY;
        isDragging = true;
        if(mapDistanceDragged >= 20) {
            closeInfoPopup(false);
        }
    }

    /**
        Mouse up handler
     **/
    private function mouseUp_handler(signal: GMouseInput): Void {
        MGDebug.INFO();
        isDragging = false;
        if(mapDistanceDragged < 20) {
            closeInfoPopup(true, signal.contextX, signal.contextY);
        }
        mapDistanceDragged = 0;
    }

    /**
        Mouse wheel handler
     **/
    private function mouseWheel_handler(signal: GMouseInput): Void {
        var target:GUIElement = cast(signal.target, GUIElement).parent;
        var change: Float = signal.delta/15;
        if(canChangeZoom) {
            if(core.getMapCamera().zoom + change < MAX_SCALE &&
                core.getMapCamera().zoom + change > MIN_SCALE) {
                canChangeZoom = false;
                GDebug.info("X: " + Std.string(signal.contextX + " Y: " + Std.string(signal.contextY)));
                mapGui.root.pivotX = signal.contextX;
                mapGui.root.pivotY = signal.contextY;
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
            var target:GUIElement = cast(signal.target, GUIElement).parent;
            handleDragDistance(signal.contextX, signal.contextY);
            var deltaX: Float = (lastX - signal.contextX) / core.getMapCamera().zoom;
            var deltaY: Float = (lastY - signal.contextY) / core.getMapCamera().zoom;
            lastX = signal.contextX;
            lastY = signal.contextY;
            for(i in 0...target.children.length) {
                target.children[i].anchorX = target.children[i].anchorX - deltaX;
                target.children[i].anchorY = target.children[i].anchorY - deltaY;
            }
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
        openInfoPopup = new InfoPopupElement();
        openInfoPopup.getGuiElement().anchorX = p_x + 5;
        openInfoPopup.getGuiElement().anchorY = p_y + 5;
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

    public function addMouseWheelListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseWheel.add(p_handler);
            }
        }
    }

    public function addMouseMoveListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseMove.add(p_handler);
            }
        }
    }

    public function addMouseOverListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseOver.add(p_handler);
            }
        }
    }

    public function addMouseOutListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseOut.add(p_handler);
            }
        }
    }

    public function addMouseDownListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseDown.add(p_handler);
            }
        }
    }

    public function addMouseUpListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseUp.add(p_handler);
            }
        }
    }

    public function addMouseClickListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseClick.add(p_handler);
            }
        }
    }

    public function zoomChanged(p_scale: Float): Void {
        var tileRow: Array<Tile>;
        for(i in 0...tiles.length) {
            tileRow = tiles[i];
            for(j in 0...tileRow.length) {
                tileRow[j].zoomChanged(p_scale);
            }
        }
    }
}
