package com.dinox.view;
import com.dinox.model.TileRarityType;
import com.dinox.model.LandSizeType;
import com.dinox.model.TileGroup;
import com.dinox.model.LandMap;
import com.genome2d.debug.GDebug;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.element.GUIElement;
import com.dinox.model.Tile;
import com.genome2d.macros.MGDebug;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
class MainMapScreen {

    private var tilesState: String;
    private var ui: UIElement;
    private var map: MapElement;
    private var  uiContainer: GUI;
    private var  mapContainer: GUI;

    public function new(p_uiGui: GUI, p_mapGui: GUI) {
        uiContainer = p_uiGui;
        mapContainer = p_mapGui;
        setupUI();
        setupMap();
    }

    private function setupUI(): Void {
        ui = new UIElement();
        uiContainer.root.addChild(ui.getGuiElement());
    }

    private function setupMap(): Void {
        map = new MapElement();
        mapContainer.root.addChild(map.getGuiElement());
    }

    public function setupTiles(): Array<Array<Tile>> {
        var tiles = new Array<Array<Tile>>();
        var tileRow: Array<Tile>;
        var tile: Tile;
        var xOffset: Float = (LandMap.TILE_COUNT / 2) * TileRenderer.BASE_TILE_SIZE;
        var yOffset: Float = xOffset;
        GDebug.info("x: " + Std.string(xOffset), "y: " + Std.string(yOffset));
        GDebug.info("START ---- " + Std.string(Date.now().toString()));
        for(i in 0...LandMap.TILE_COUNT) {
            tileRow = new Array<Tile>();
            for(j in 0...LandMap.TILE_COUNT) {
//                tile = new Tile(i * TileRenderer.BASE_TILE_SIZE - xOffset, j * TileRenderer.BASE_TILE_SIZE - yOffset, i, j);
//                tileRow.push(tile);
//                map.getGuiElement().addChild(tile.getTileElement());
//                addListenersToTile(tile);
            }
            tiles.push(tileRow);
        }
        GDebug.info("END ---- " + Std.string(Date.now().toString()));
        renderNormalTexture();
//        map.getGuiElement().onMouseWheel.add(mouseWheelListener);
        return tiles;
    }

    public function renderSmallTexture(): Void {
        if(tilesState!= TileRenderer.SMALL_STATE) {
            tilesState = TileRenderer.SMALL_STATE;
            map.getGuiElement().setState(TileRenderer.SMALL_STATE);
        }
    }

    public function renderNormalTexture(): Void {
        if(tilesState!= TileRenderer.NORMAL_STATE) {
            tilesState = TileRenderer.NORMAL_STATE;
            map.getGuiElement().setState(TileRenderer.NORMAL_STATE);
        }
    }

    public function renderLargeTexture(): Void {
        if(tilesState!= TileRenderer.LARGE_STATE) {
            tilesState = TileRenderer.LARGE_STATE;
            map.getGuiElement().setState(TileRenderer.LARGE_STATE);
        }
    }


    public function addSizeFilterListener(p_handler: GMouseInput->Void): Void {
        ui.getGuiElement().getChildByName(LandSizeType.ONEXONE, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(LandSizeType.TWOXTWO, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(LandSizeType.THREEXTHREE, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(LandSizeType.FOURXFOUR, true).onMouseDown.add(p_handler);
    }

    public function addRarityFilterListener(p_handler: GMouseInput->Void): Void {
        ui.getGuiElement().getChildByName(TileRarityType.COMMON, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.UNCOMMON, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.RARE, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.LEGENDARY, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.MYTHICAL, true).onMouseDown.add(p_handler);
    }
}
