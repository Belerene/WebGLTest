package com.dinox.view;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.TileSizeType;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.input.GMouseInput;
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
        ui.getGuiElement().getChildByName("one", true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName("two", true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName("three", true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName("four", true).onMouseDown.add(p_handler);
    }

    public function addRarityFilterListener(p_handler: GMouseInput->Void): Void {
        ui.getGuiElement().getChildByName(TileRarityType.COMMON, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.UNCOMMON, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.RARE, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.LEGENDARY, true).onMouseDown.add(p_handler);
        ui.getGuiElement().getChildByName(TileRarityType.MYTHICAL, true).onMouseDown.add(p_handler);
    }
}
