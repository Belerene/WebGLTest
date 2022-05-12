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

    public function new(p_uiGui: GUI, p_mapGui: GUI, p_core: Core) {
        core = p_core;
        uiGui = p_uiGui;
        mapGui = p_mapGui;
        mainMapScreen = new MainMapScreen(uiGui, mapGui);
        addMainMapScreenListeners();
    }

    private function addMainMapScreenListeners(): Void {
        mainMapScreen.addMouseWheelListener(mouseWheel_handler);
        mainMapScreen.addMouseMoveListener(mouseMove_handler);
        mainMapScreen.addMouseOverListener(mouseOver_handler);
        mainMapScreen.addMouseOutListener(mouseOut_handler);
        mainMapScreen.addMouseDownListener(mouseDown_handler);
        mainMapScreen.addMouseUpListener(mouseUp_handler);
        mainMapScreen.addMouseClickListener(mouseClick_handler);
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
        mainMapScreen.zoomChanged(scaleAfterChange);
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
}
