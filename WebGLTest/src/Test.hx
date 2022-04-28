package ;
import com.genome2d.project.GProjectConfig;
import com.genome2d.project.GProject;
import com.genome2d.components.GScriptComponent;
import com.genome2d.components.GCameraController;
import com.genome2d.components.GComponent;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GShape;
import com.genome2d.macros.MGDebug;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.context.GBlendMode;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
import com.genome2d.debug.GDebug;
import js.Browser;
import com.genome2d.Genome2D;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.components.renderable.GSprite;
class Test extends GProject{
    static public function main() {
        var inst = new Test();
    }

    private var container:GNode;
    private var containerCamera:GCameraController;

    private var initType:Int = 0;

    public function new(?p_init:Int = 0) {
        initType = p_init;
        var contextConfig:GContextConfig = new GContextConfig(null);
        var config:GProjectConfig = new GProjectConfig(contextConfig);
        config.initGenome = initType == 0;
        super(config);
    }

    override private function init():Void {
        if (initType != 2) {
            GDebug.warning("init 1");
            GStaticAssetManager.addFromUrl("assets/2048.png");

            GStaticAssetManager.loadQueue(assetsLoaded_handler, assetsFailed_handler);
        } else {
            GDebug.warning("init 2");
            initWrapper();
        }
    }

    private function initWrapper():Void {
        var root:GNode = getGenome().root;

        container = new GNode();
        container.cameraGroup = 1;
        root.addChild(container);

        containerCamera = cast(GNode.createWithComponent(GCameraController),GCameraController);
        containerCamera.node.setPosition(400, 300);
        containerCamera.contextCamera.group = 1;
        root.addChild(containerCamera.node);

        var infoCamera:GCameraController = cast(GNode.createWithComponent(GCameraController),GCameraController);
        infoCamera.node.setPosition(400, 300);
        infoCamera.contextCamera.group = 128;
        root.addChild(infoCamera.node);


        initExample();
    }

    /**
		 * 	Asset loading failed
		 */
    private function assetsFailed_handler(p_asset:GAsset):Void {
        MGDebug.ERROR(p_asset.id);
    }

    /**
		 * 	Asset loading completed
		 */
    private function assetsLoaded_handler():Void {
        GStaticAssetManager.generate();

        initWrapper();
    }

    public function initExample():Void {
        var shape:GShape = cast(GNode.createWithComponent(GShape),GShape);
        shape.setup([0,0, 650, 0, 0, 350, 0, 350, 650, 0, 650, 350],[0,0,1,0,0,1,0,1,1,0,1,1]);
        shape.texture = GTextureManager.getTexture("assets/2048.png");
        shape.node.setPosition(60,150);
        getGenome().root.addChild(shape.node);
    }

}
