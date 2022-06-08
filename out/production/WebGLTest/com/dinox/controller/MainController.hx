package com.dinox.controller;
import com.genome2d.debug.GDebug;
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
    private var mouseDragHandler: Float->Float->Void;
    private var infoPopupHandler: Float->Float->GCamera->Void;

    private var DEV_mouseDragHandler: Float->Float->GCamera->Void;
    private var DEV_mouseDownHandler: Float->Float->GCamera->Void;

    private var zoomCompletedHandler: Float->Void;
    public function new(p_core: Core) {
        core = p_core;
    }

    public function addMapScreenListeners(p_mouseDragHandler: Float->Float->Void, p_infoPopupHandler: Float->Float->GCamera->Void, p_zoomCompletedHandler: Float->Void): Void {
        mouseDragHandler = p_mouseDragHandler;
        infoPopupHandler = p_infoPopupHandler;
        zoomCompletedHandler = p_zoomCompletedHandler;
        core.getMapCamera().onMouseInput.add(handleMapCameraMouseInput);
    }

    public function addDevMapScreenListeners(p_DEV_mouseDragHandler: Float->Float->GCamera->Void, p_DEV_mouseDownHandler: Float->Float->GCamera->Void): Void {
        DEV_mouseDragHandler = p_DEV_mouseDragHandler;
        DEV_mouseDownHandler = p_DEV_mouseDownHandler;
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

    public function addUiFilterListeners(p_uiElement: GUIElement, p_sizeFilterHandler: GMouseInput->Void, p_rarityFilterHandler: GMouseInput->Void, p_devUiHandler: GMouseInput->Void = null): Void {
        addSizeFilterListeners(p_sizeFilterHandler, p_uiElement);
        addRarityFilterListeners(p_rarityFilterHandler, p_uiElement);
    }

    public function addSizeFilterListeners(p_handler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        p_uiElement.getChildByName("one", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("two", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("three", true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName("four", true).onMouseDown.add(p_handler);
    }

    public function addRarityFilterListeners(p_handler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        p_uiElement.getChildByName(TileRarityType.COMMON, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.UNCOMMON, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.RARE, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.LEGENDARY, true).onMouseDown.add(p_handler);
        p_uiElement.getChildByName(TileRarityType.MYTHICAL, true).onMouseDown.add(p_handler);
    }

    public function addDevUIListener(p_handler: GMouseInput->Void, p_uiElement: GUIElement): Void {
        p_uiElement.getChildByName("move_enabled", true).onMouseDown.add(p_handler);
    }

    public function addDevInfoPopupHandlers(p_rarity_handler: GMouseInput->Void, p_size_handler: GMouseInput->Void, p_asset_handler: GMouseInput->Void, p_infoPopupElement: GUIElement): Void {
        p_infoPopupElement.getChildByName("info_popup_rarity_l", true).onMouseDown.add(p_rarity_handler);
        p_infoPopupElement.getChildByName("info_popup_rarity_r", true).onMouseDown.add(p_rarity_handler);
        p_infoPopupElement.getChildByName("info_popup_size_l", true).onMouseDown.add(p_size_handler);
        p_infoPopupElement.getChildByName("info_popup_size_r", true).onMouseDown.add(p_size_handler);
        p_infoPopupElement.getChildByName("info_popup_asset_l", true).onMouseDown.add(p_asset_handler);
        p_infoPopupElement.getChildByName("info_popup_asset_r", true).onMouseDown.add(p_asset_handler);
    }

    public function removeDevInfoPopupHandlers(p_infoPopupElement: GUIElement): Void {
        p_infoPopupElement.getChildByName("info_popup_rarity_l", true).onMouseDown.removeAll();
        p_infoPopupElement.getChildByName("info_popup_rarity_r", true).onMouseDown.removeAll();
        p_infoPopupElement.getChildByName("info_popup_size_l", true).onMouseDown.removeAll();
        p_infoPopupElement.getChildByName("info_popup_size_r", true).onMouseDown.removeAll();
        p_infoPopupElement.getChildByName("info_popup_asset_l", true).onMouseDown.removeAll();
        p_infoPopupElement.getChildByName("info_popup_asset_r", true).onMouseDown.removeAll();
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

        if(Main.IS_DEV) {
            if(DEV_mouseDownHandler != null) {
                var x: Float = signal.worldX;
                var y: Float = signal.worldY;
                DEV_mouseDownHandler(x, y, signal.camera.contextCamera);
            }
        }

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
            if(mouseDragHandler != null) {
                mouseDragHandler(deltaX, deltaY);
            }
            if(Main.IS_DEV) {
                if(DEV_mouseDragHandler != null) {
                    DEV_mouseDragHandler(signal.worldX, signal.worldY, signal.camera.contextCamera);
                }
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
