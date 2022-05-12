package com.dinox;
import com.genome2d.debug.GDebug;
import com.genome2d.components.GCameraController;
import com.genome2d.node.GNode;
import com.dinox.model.Core;
import com.genome2d.context.GContextConfig;
import com.genome2d.project.GProjectConfig;
import com.genome2d.project.GProject;
class Main extends GProject{

    public static var  stageWidth: Int = 0;
    public static var  stageHeight: Int = 0;

    private var initType:Int = 0;

    private var core: Core;


    private var container: GNode;
    private var containerCamera: GCameraController;

    static public function main() {
        var inst = new Main();
    }

    public function new(?p_init:Int = 0) {
        initType = p_init;
        var contextConfig:GContextConfig = new GContextConfig(null);
        stageWidth = contextConfig.nativeStage.width;
        stageHeight = contextConfig.nativeStage.height;
        var config:GProjectConfig = new GProjectConfig(contextConfig);
        config.initGenome = initType == 0;
        super(config);
    }

    override private function init():Void {
        core = new Core(getGenome().root);
    }
}
