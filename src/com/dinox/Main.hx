package com.dinox;
import com.genome2d.geom.GRectangle;
import com.genome2d.Genome2D;
import com.genome2d.debug.GDebug;
import js.Browser;
import com.genome2d.context.stats.GStats;
import com.genome2d.components.GCameraController;
import com.genome2d.node.GNode;
import com.dinox.model.Core;
import com.genome2d.context.GContextConfig;
import com.genome2d.project.GProjectConfig;
import com.genome2d.project.GProject;
class Main extends GProject{

    public static var stageWidth: Int = 0;
    public static var stageHeight: Int = 0;
    public static var IS_DEV: Bool = true;

    private var initType:Int = 0;

    private var core: Core;


    private var container: GNode;
    private var containerCamera: GCameraController;
    private var resizer:Resizer = new Resizer("a");

    static public function main() {
        var inst = new Main();
    }

    public function new(?p_init:Int = 0) {
        initType = p_init;
        var contextConfig:GContextConfig = new GContextConfig(null);
        Browser.document.getElementById("canvas").addEventListener("resize", test);
        stageWidth = contextConfig.nativeStage.width;
        stageHeight = contextConfig.nativeStage.height;
        trace(stageWidth, stageHeight);
        var config:GProjectConfig = new GProjectConfig(contextConfig);
        config.initGenome = true;
//        GStats.visible = true;
        super(config);
    }

    @:expose("resizeMap") static function resizeMap(w,h) {
        Genome2D.getInstance().getContext().resize(new GRectangle(0,0,w,h));
    }

    override private function init():Void {
        getGenome().getContext().setBackgroundColor(0x10466a,1);
        core = new Core(getGenome().root);
    }

    private function test(): Void {
        GDebug.info("TEST________________________________________2");
    }
}