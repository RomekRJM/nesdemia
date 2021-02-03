# Immunatio
Using #stayathome as an opportunity to write a retro NES game about battling pandemic. I decided to sell it on a cartridge and in the form of rom files, giving all earnings to Polish charity called WOŚP.

Below you can find youtube review by Korpokrowa ( it's in Polish ):

[![IMMUNATIO review](https://img.youtube.com/vi/0hyVntmwJzo/0.jpg)](https://www.youtube.com/watch?v=0hyVntmwJzo)

<img src="https://raw.githubusercontent.com/RomekRJM/nesdemia/master/screenshots/cartridge.png" width="525px" height="300px">

<img src="https://raw.githubusercontent.com/RomekRJM/nesdemia/master/screenshots/nesdemia-0.png" width="400px" height="340px">

<img src="https://raw.githubusercontent.com/RomekRJM/nesdemia/master/screenshots/nesdemia-1.png" width="400px" height="340px">


## Media
Game got some recognition in local Polish media
* [arhn.eu](https://arhn.eu/2021/01/immunatio-wosp/)
* [wykop.pl](https://www.wykop.pl/link/5882189/immunatio-moja-nowa-gra-na-pegasusa-dla-wosp/)
* [radiokampus.fm](https://radiokampus.fm/aktualnosci/pokonaj-koronawirusa-na-pegasusie/?fbclid=IwAR06xXHWOxqA7DX6ZIVf05gaGHhUjDnhXRWbLmMWOOzW2oKL1waRRJJowD0)
* [gry.interia.pl](https://gry.interia.pl/newsy/news-immunatio-to-nowa-gra-na-pegasusa,nId,4968668)
* [graczpospolita.pl](https://graczpospolita.pl/nowa-polska-gra-na-pegasusa-sprzedana-za-czterocyfrowa-kwote/)

## Authors
* Programming: Roman Subik.
* Graphics: RETHUNTER, Roman Subik, Dorota Subik.
* Music: ‪Håvard Handergård.
* Uses ggsound music engine by Derek Andrews
* Testing and bug reports: Maciej Jaszak, Michał Igel.
* Was released on a cartridge Krzysio Cart by Krzysztof Bałażyk.
* Title idea: Tomasz Nabagło.


## MOD
Mariusz Jałyński has moded this game, changing all the graphics and giving it a much darker vibe. I highly recommend you to try it:
https://raw.githubusercontent.com/RomekRJM/nesdemia/master/nesdemia_mod.nes

<img src="https://raw.githubusercontent.com/RomekRJM/nesdemia/master/screenshots/nesdemia_mod-0.png" width="400px" height="340px">


## Version history

**1.0 - 03.02.2021**

Organisational:
* Game was released on a Krzysio Cart cartridge prepared by Krzysztof Bałażyk.
* It was sold as a cartridge and roms. All money gathered went to charity WOŚP.
* Game was promoted in the media: wykop.pl, arhn.eu and some other portals.

Enhancements
* Background of each level changes based on mission objective.
* Password screen now more descriptive.
* Added game ending screen.
* You can leave password screen by pressing select.
* Added more contributors to credits.

Bug fixes
* Game on some occasions was giving the player 9 lives after the last live was lost.
* Fixed level loading algorithm, which caused display artefacts after level 22.
* Decreased time beetween last hit and pre level/game over screens as people believed it was a bug.
* Fixed audio and joypad conflict, which was causing occasional right arrow presses in the Mesen emulator and some consoles.



**0.4 - 04.01.2021**

Enhancements
* Game now has 32 levels, most of them procedurally generated.
* Added animated main menu graphics by RetHunter.
* Better lung and powerups graphics by RetHunter.
* Added more contributors to the credits.

Balance
* Player now has 3 lives.
* New round no longer starts where the old one finished.
* Increased attributes prices in the shop.

Bug fixes
* Fixed level counter.
* Prices are now always correct on the newly displayed shop screen.
* Header HUD icons don't display when the player is at the top of the screen.
* Fixed artefact when displaying "WRONG" on password screen.



**0.3 - 21.12.2020**

Enhancements
* Speed, attack and luck bought in the shop improve player abilities.
* Palette reload in NMI. Menus look better.
* Display mission objective on pre level screen.

Bug fixes
* Fixed artefacts on game over and pre level screens.
* Improved collisions with power ups.
* Pre level screen correctly displays level number.
* Fixed collision detection with virus when player does not move.
* Music does not stop anymore, when a new level is loaded.
* Credits does not include main menu options when opened multiple times in a row.
* Improved display area on real TVs.
* Fixed load game functionality.
* Removed background from fonts in menus.



**0.2 - 11.11.2020**

Enhancements
* Added support for GGSound engine by Derek Andrews.
* Game has music composed by ‪Håvard Handergård.
* Added shop.
* New credits screen.
* Save/load functionality with passphrases.
* New level introduction screen.

Balance
* Removed difficulty levels as they did not have much sense at this stage.



**0.1 - 27.07.2020**
* First playable version with 5 levels.
* Can be completed.
