package com.dinox.view;
import com.genome2d.ui.element.GUIElement;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.TileSizeType;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.input.GMouseInput;
class MainMapScreen {

    private var tilesState: String;
    private var ui: UIElement;
    private var tileHighlightsHolder: TileHighlightsHolderElement;
    private var map: MapElement;
    private var  uiContainer: GUI;
    private var  tileHighlightContainer: GUI;
    private var  mapContainer: GUI;

    public function new(p_uiGui: GUI, p_tileHighlightGui: GUI, p_mapGui: GUI) {
        uiContainer = p_uiGui;
        tileHighlightContainer = p_tileHighlightGui;
        mapContainer = p_mapGui;
        setupUI();
        setupTileHighlightContainer();
        setupMap();
    }

    private function setupUI(): Void {
        ui = new UIElement();
        uiContainer.root.addChild(ui.getGuiElement());
    }

    private function setupTileHighlightContainer(): Void {
        tileHighlightsHolder = new TileHighlightsHolderElement();
        tileHighlightContainer.root.addChild(tileHighlightsHolder.getGuiElement());
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

    public function getUiElement(): UIElement {
        return ui;
    }



}
