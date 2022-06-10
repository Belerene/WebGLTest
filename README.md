1. Clone https://github.com/pshtif/Genome2D
2. Download Haxe 4 set it as Project and Module SDK https://haxe.org/ (latest intellij version supporting haxe is 2020.3.4)
3. Project language level: plain old Java
4. Set Project SDK, Neko executable HaxeToolkit\neko\neko.exe, Haxelib executable HaxeToolkit\haxe\haxelib.exe
5. Setup your project libraries:
    - Genome2D\Genome2D-ContextCommon\src
    - Genome2D\Genome2D-ContextHTML\src
    - Genome2D\Genome2D-Core\src
6. Setup Modules>Haxe Compile With  HXML, Target JavaScript, HXML file Git\Project\build.hxml
7. Set your Run/Debug Configuration - Haxe Application. Use Custom file to run: Git\Project\build.hxml
8. Download Xampp and symlink from your project out folder to your xampp\htdocs\project folder (for instance mklink /D C:\xampp\htdocs\out C:\Gity\WebGLTest\out) https://www.apachefriends.org/download.html 
9. Create symlink from project assets to out/assets
10. Check localhost http://localhost/out/test.php
11. Copy contents of localGenome2DChanges folder into your Genome2D folder (or read the README.txt there)