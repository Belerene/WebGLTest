package com.dinox.model;
import com.genome2d.debug.GDebug;
import com.dinox.view.TileRenderer;
import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenStep;
import com.genome2d.ui.element.GUIElement;
class Cloud {
    private var element: GUIElement;
    private var step: GTweenStep;
    private var mapDimension: Int;
    private var change: Int = 180;
    private var speed: Float = 3;
    public var target: Float;

    public function new(p_cloudElement: GUIElement) {
        element = p_cloudElement;
        mapDimension = Math.round((TileRenderer.BASE_TILE_SIZE * LandMap.TILE_COUNT) * 4);
        var mapDimensionY:Int = (TileRenderer.BASE_TILE_SIZE * LandMap.TILE_COUNT)*2;
        element.anchorX = Std.random(mapDimension) - Std.int(mapDimension/2);
        element.anchorY = (Std.random(mapDimensionY) - Std.int(mapDimensionY/2)) - 200;
        speed -= (Std.random(150)/100)+1;
        if(element.anchorX >= 0) {
            target = element.anchorX + change;
        } else {
            target = element.anchorX + change;
        }

        step = GTween.create(element, true).ease(GLinear.none).propF("anchorX", target, speed, false).onComplete(moveComplete);
    }

    private function moveComplete(): Void {
        if(element.anchorX >= mapDimension/2) {
            moveToStartOfMapFadeOut();
        } else {
            if(step != null) {
                if(element.anchorX >= 0) {
                    target = element.anchorX + change;
                } else {
                    target = element.anchorX + change;
                }
                disposeStep();
                step = GTween.create(element, true).ease(GLinear.none).propF("anchorX", target, speed, false).onComplete(moveComplete);
            }
        }
    }

    private function disposeStep(): Void {
        if(step!= null) {
            step.dispose();
            step = null;
        }
    }

    private function moveToStartOfMapFadeOut(): Void {
        if(step != null) {
            disposeStep();
        }
        step = GTween.create(element, true).ease(GLinear.none).propF("alpha", 0, 0.5, false).onComplete(fadeIn);
    }

    private function fadeIn(): Void {
        if(step != null) {
            disposeStep();
        }
        element.anchorX = -mapDimension/2 - 1000;
        step = GTween.create(element, true).ease(GLinear.none).propF("alpha", 1, 0.5, false).onComplete(moveComplete);
    }

    public function getElement(): GUIElement {
        return  element;
    }
}
