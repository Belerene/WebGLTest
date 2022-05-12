package com.dinox.view;
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
        for(i in 0...LandMap.TILE_COUNT) {
            tileRow = new Array<Tile>();
            for(j in 0...LandMap.TILE_COUNT) {
                tile = new Tile(i * TileRenderer.BASE_TILE_SIZE - xOffset, j * TileRenderer.BASE_TILE_SIZE - yOffset, i, j);
                tileRow.push(tile);
                map.getGuiElement().addChild(tile.getTileElement());
            }
            tiles.push(tileRow);
        }
        return tiles;
    }


}
