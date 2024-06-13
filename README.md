## Warhammer SS40K (Codename: SS40K)
![Icon](https://github.com/GalacticCoalition/Warhammer-SS40K/assets/9026500/7d817cb2-4efb-4f46-acba-cb4ef7d24ac0)

[![CI Suite](https://github.com/Skyrat-SS13/Skyrat-tg/workflows/CI%20Suite/badge.svg)](https://github.com/Skyrat-SS13/Skyrat-tg/actions?query=workflow%3A%22CI+Suite%22)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/Skyrat-SS13/Skyrat-tg.svg)](https://isitmaintained.com/project/Skyrat-SS13/Skyrat-tg "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/Skyrat-SS13/Skyrat-tg.svg)](https://isitmaintained.com/project/Skyrat-SS13/Skyrat-tg "Average time to resolve an issue")
![Coverage](https://img.shields.io/codecov/c/github/Skyrat-SS13/Skyrat-tg)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website                   | Link                                           |
|---------------------------|------------------------------------------------|
| Git / GitHub cheatsheet   | [https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833](https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833) |
| Website                   | [https://www.tgstation13.org](https://www.tgstation13.org)          |
| Wiki                      | [https://warhammer-ss40k.fandom.com/wiki/Warhammer_SS40K_Wiki](https://warhammer-ss40k.fandom.com/wiki/Warhammer_SS40K_Wiki)  |
| Codedocs                  | ----
| Warhammer SS40K Discord   | [SS40K Discord](https://discord.gg/hmcdTHtEXQ)
| Coderbus Discord          | [https://discord.gg/Vh8TJp9](https://discord.gg/Vh8TJp9)               |

This is a Warhammer 40K Space Station 13 derivative. As true to nature as possible.

This is based on Skyrat build July 2024.

## DOWNLOADING

[Downloading](.github/guides/DOWNLOADING.md)

[Running on the server](.github/guides/RUNNING_A_SERVER.md)

[Maps and Away Missions](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## Compilation

Find `BUILD.bat` here in the root folder of tgstation, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Contributors

[Guides for Contributors](.github/CONTRIBUTING.md)

[/tg/station HACKMD account](https://hackmd.io/@tgstation) - Design documentation here

[Interested in some starting lore?](https://github.com/tgstation/common_core)

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
