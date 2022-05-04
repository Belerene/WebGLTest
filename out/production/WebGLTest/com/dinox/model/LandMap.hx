package com.dinox.model;
import com.genome2d.macros.MGDebug;
import com.genome2d.input.GMouseInput;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.debug.GDebug;
import com.genome2d.textures.GTextureManager;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
class LandMap {
//    private var core: Core;
    private static var MAX_SCALE: Float = 2;
    private static var MIN_SCALE: Float = 0.1;



    private var  graphicsContainer: GNode;
    private var isDragging: Bool = false;
    private var lastX: Float;
    private var lastY: Float;

    public function new(p_graphicsContainer: GNode) {
        graphicsContainer = p_graphicsContainer;
        var graphics: GSprite = cast(GNode.createWithComponent(GSprite),GSprite);
        var texture:GTexture = GTextureManager.getTexture("dinos");


        var sprite:GSprite = cast(GNode.createWithComponent(GSprite), GSprite);
        sprite.texture = GTextureManager.getTexture("dinos");
        sprite.node.setPosition(400, 300);
        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClick_handler);
        sprite.node.onMouseOver.add(mouseOver_handler);
        sprite.node.onMouseOut.add(mouseOut_handler);
        sprite.node.onMouseDown.add(mouseDown_handler);
        sprite.node.onMouseUp.add(mouseUp_handler);
        sprite.node.onMouseWheel.add(mouseWheel_handler);
        sprite.node.onMouseMove.add(mouseMove_handler);

        graphicsContainer.addChild(sprite.node);

    }



    /**
        Mouse click handler
     **/
    private function mouseClick_handler(signal: GMouseInput): Void {
        MGDebug.INFO();
    }

    /**
        Mouse over handler
     **/
    private function mouseOver_handler(signal: GMouseInput): Void {
        var node:GNode = cast signal.target;
//        node.setScale(1.2, 1.2);
        node.rotation += Math.PI / 80;
//        node.color = 0x00FF00;
        MGDebug.INFO();
    }

    /**
        Mouse out handler
     **/
    private function mouseOut_handler(signal: GMouseInput): Void {
        var node:GNode = cast signal.target;
//        node.setScale(1, 1);
        node.rotation += Math.PI / 80;
        node.color = 0xFFFFFF;
        MGDebug.INFO();
    }

    /**
        Mouse down handler
     **/
    private function mouseDown_handler(signal: GMouseInput): Void {
        MGDebug.INFO();
        lastX = signal.contextX;
        lastY = signal.contextY;
        isDragging = true;
    }

    /**
        Mouse up handler
     **/
    private function mouseUp_handler(signal: GMouseInput): Void {
        MGDebug.INFO();
        isDragging = false;
    }

    /**
        Mouse wheel handler
     **/
    private function mouseWheel_handler(signal: GMouseInput): Void {
        MGDebug.INFO(Std.string(signal.delta));
        var node:GNode = cast signal.target;
        var change: Float = signal.delta/20;
        if(node.scaleX + change < MAX_SCALE &&
           node.scaleY + change < MAX_SCALE &&
           node.scaleX + change > MIN_SCALE &&
           node.scaleY + change > MIN_SCALE){
            node.setScale(node.scaleX + change, node.scaleY + change);
        }
    }

    /**
        Mouse move handler
     **/
    private function mouseMove_handler(signal: GMouseInput): Void {
        if(isDragging){
            var node:GNode = cast signal.target;
            var deltaX: Float = lastX - signal.contextX;
            var deltaY: Float = lastY - signal.contextY;
            lastX = signal.contextX;
            lastY = signal.contextY;
            MGDebug.INFO(Std.string(deltaX), Std.string(deltaY));
            node.setPosition(node.x - deltaX, node.y - deltaY);
        }
    }
}
