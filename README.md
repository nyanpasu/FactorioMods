# Factorio Mods
A mod database for Factorio.

## Upcoming features

- Integration with Github
  - Automatically scrap the releases from mods hosted in Github instead
    of adding the releases manually and hosting them on AWS.
  - Automatically use the Github README file as mod description and
    use the first pharagraph as summary
- Read dependencies from the info.json file in the zipped
  - Actually add inter-mod dependencies, for now it just saves information about the Factorio version required
- Fork [Factorio Mod Manager](https://github.com/narrowtux/FactorioModManager/) or convince someone
  that actually knows Java to register a `factoriomod://` protocol to automatically download and
  install the mods by clicking "install" on the web app
- Add bookmarks functionality for users to save mods and access them easily
- Track mods downloads and visits, for stats, and for later history checking by users
- Add a more automated way to authorize developers, instead of receiving PMs in the forum
- Support for multiple authors
- Support for mod forking detection
- I noticed a few devs use AdFly to get a little support,
  maybe I could add a pop up on the first download and ask the user if he wants
  to activate an "dev-support-download toggle" to turn all downloads into AdFly links
  for the dev. And maybe a custom YouTube video link, also for support.