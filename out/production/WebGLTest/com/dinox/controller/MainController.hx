package com.dinox.controller;
import com.genome2d.context.GCamera;
import com.genome2d.tween.GTween;
import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTweenStep;
import com.dinox.model.tile.TileRarityType;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.input.GMouseInputType;
import com.genome2d.input.GMouseInput;
import com.dinox.model.Core;
class MainController {
    private static var MAX_SCALE: Float = 2;
    private static var MIN_SCALE: Float = 0.2;

    private var canChangeZoom: Bool = true;
    private var isDragging: Bool = false;
    private var lastX: Float;
    private var lastY: Float;
    private var mapDistanceDragged: Float = 0;
    private var _canHideInfoPopup: Bool = true;
    public var canHideInfoPopup(get, set):Bool;
    inline private function get_canHideInfoPopup(): Bool {
        return _canHideInfoPopup;
    }
    inline private function set_canHideInfoPopup(p_canHideInfoPopup: Bool): Bool {
        _canHideInfoPopup = p_canHideInfoPopup;
        return _canHideInfoPopup;
    }

    private var core: Core;
    private var mouseDragCompleted: Float->Float->Void;
    private var infoPopupHandler: Float->Float->GCamera->Void;
    private var zoomCompletedHandler: Float->Void;
    public function new(p_core: Core) {
        core = p_core;
    }

    public function addMapScreenListeners(p_mouseDragCompleted: Float->Float->Void, p_infoPopupHandler: Float->Float->GCamera->Void, p_zoomCompletedHandler: Float->Void): Void {
        mouseDragCompleted = p_mouseDragCompleted;
        infoPopupHandler = p_infoPopupHandler;
        zoomCompletedHandler = p_zoomCompletedHandler;
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

    public function addUiFilterListeners(p_sizeFilterHandler: GMouseInput->Void, p_rarityFilterHandler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        addSizeFilterListener(p_sizeFilterHandler, p_uiElement);
        addRarityFilterListener(p_rarityFilterHandler, p_uiElement);
    }

    public function addSizeFilterListener(p_handler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        p_uiElement.getChildByName("one", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("two", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("three", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("four", true).onMouseDown.add(p_handler);
    }

    public function addRarityFilterListener(p_handler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        p_uiElement.getChildByName(TileRarityType.COMMON, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.UNCOMMON, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.RARE, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.LEGENDARY, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.MYTHICAL, true).onMouseDown.add(p_handler);
    }

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
            infoPopupHandler(x,y, signal.camera.contextCamera);
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
            if(mouseDragCompleted != null) {
                mouseDragCompleted(deltaX, deltaY);
            }
        }
    }

    private function handleDragDistance(p_x: Float, p_y: Float): Void {
        var distance: Float = Math.sqrt(Math.pow(p_x - lastX, 2) + Math.pow(p_y - lastY, 2));
        mapDistanceDragged += distance;
    }

    public function onCompleteShowInfoPopup(): Void {
        canHideInfoPopup = true;
    }

    private function onCompleteZoom(scaleAfterChange: Float):Void {
        zoomCompletedHandler(scaleAfterChange);
        canChangeZoom = true;
    }
}