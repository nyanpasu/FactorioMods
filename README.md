# Factorio Mods [![Build Status](https://travis-ci.org/Zequez/FactorioMods.svg)](https://travis-ci.org/Zequez/FactorioMods)

[FactorioMods.com](http://factoriomods.com) it's an open
source web app to host Factorio Mods, and make it easier for user and devs alike
to share, find, download, and manage mods.

[Trello board with tasks being worked, ideas, planning and stuff](https://trello.com/b/Ii5IHVxG/factoriomods). For bug report use the Github issues.

## Is FactorioMods a mod manager?

No, FactorioMods it's not a mod manager, after you download the mods, you have to install them
yourself. However there is another open source app, [FactorioModManager](https://github.com/narrowtux/FactorioModManager) that
allows you to do just that, and [here is the forum post with instructions of how to use it](http://www.factorioforums.com/forum/viewtopic.php?f=69&t=13327).

Since these are both open source apps, it's just a matter of time until
we can coordinate to use a common protocol to install mods in the same way
that NexusModManager does it.

## API to get mods

The API and the API documentation are a WIP, but some
features are already working and some basic docs are already here:

The API lives in [api.factoriomods.com](http://api.factoriomods.com), going there
you can see list of available URLs (authors and users APIs not working yet)

You can get a list of mods by calling [/mods](http://api.factoriomods.com/mods) or by calling [/mods/{mod}](http://api.factoriomods.com/mods/torches). The first one returns an array,
and the later, a single object. Or [/mods?names=mod-name,mod-name2,another-mod](http://api.factoriomods.com/mods?names=mod-name,mod-name2,another-mod)

The structure of the mods given by the API is the following:

```javascript
{
    "title": "Example Mod!",
    "name": "example-mod", // This is the name on the info.json file
    "url": "http://www.factoriomods.com/mods/example-mod",
    "description": "The summary of what the mod does.",
    "homepage": "", // Official site
    "contact": "", // Author contact information
    "author": "That guy", // Main author
    "categories": ["logistics-network", "map", "player"]
    "releases": [{
        "version": "0.1.2",
        "released_at": "2015-07-22T00:00:00.000Z",
        "game_versions": ["0.11.x", "0.12.x"], // This list of versions the mod works with. But it's actually a range, not a list
        "dependencies": [], // This should be the dependencies listed on info.json but it's empty for now
        "files": [{
            "name": "",
            "url": "http://www.factorioforums.com/forum/download/file.php?id=4726",
            "mirror": "http://s3.amazonaws.com/factoriomods/mod_files/attachments/000/000/222/original/example-mod.zip?1437683360"
        }]
    }, {
        "version": "0.1.1",
        "released_at": "2015-07-15T00:00:00.000Z",
        "game_versions": ["0.11.x"],
        "dependencies": [],
        "files": [{
            "name": "",
            "url": "http://www.factorioforums.com/forum/download/file.php?id=4484",
            "mirror": "http://s3.amazonaws.com/factoriomods/mod_files/attachments/000/000/206/original/example-mod.zip?1437014505"
        }]
    }]
}
```

Yes, the main URL is an external hotlink, bandwidth costs
money, I'm cheap and poor. It that link it's broken you
can use the mirror hosted on the project S3 bucket.

## factoriomods:// protocol

The URIs look like the following:

```
factoriomods://eyJpZCI6NDYsInVybCI6Imh0dHA6Ly93d3cuZmFjdG9yaW9tb2RzLmNvbS9tb2RzL3VwZGF0ZWQtZ3JhcGhpY3MiLCJjYXRlZ29yaWVzIjpbInRleHR1cmUtcGFja3MiXSwiYXV0aG9ycyI6WyJ5LnBldHJlbWFubiJdLCJjb250YWN0IjoiIiwidGl0bGUiOiJVcGRhdGVkIEdyYXBoaWNzIiwibmFtZSI6InVwZGF0ZWQtZ3JhcGhpY3MiLCJkZXNjcmlwdGlvbiI6IlRoaXMgbW9kIHVwZGF0ZSBzb21lIGdyYXBoaWNzIHRvIG9mZmljaWFsIGFuZCB1bm9mZmljaWFsIGZhbmNpZXIgZ3JhcGhpY3MuXHJcblxyXG5JdCB1c2VzIGEgdGV4dHVyZSBwYWNrIHRvb2xraXQgSSd2ZSBtYWRlIHdoaWNoIHBlcm1pdCB0byB1cGRhdGUgYWxsIHVzZSBvZiBzcGVjaWZpYyBncmFwaGljcyB3aXRob3V0IGtub3dpbmcgd2hlcmUgdGhleSdyZSB1c2VkLiIsImhvbWVwYWdlIjoiIiwicmVsZWFzZXMiOlt7ImlkIjoyNDUsInZlcnNpb24iOiIwLjEyLjEiLCJyZWxlYXNlZF9hdCI6IjIwMTUtMDgtMDZUMDA6MDA6MDAuMDAwWiIsImdhbWVfdmVyc2lvbnMiOlsiMC4xMS54IiwiMC4xMi54Il0sImRlcGVuZGVuY2llcyI6W10sImZpbGVzIjpbeyJpZCI6MjUxLCJuYW1lIjoiIiwibWlycm9yIjpudWxsLCJ1cmwiOiJodHRwczovL2dpdGh1Yi5jb20vWVBldHJlbWFubi91cGRhdGVkLWdyYXBoaWNzL3JlbGVhc2VzL2Rvd25sb2FkL3VwZGF0ZWQtZ3JhcGhpY3NfMC4xMi4xL3VwZGF0ZWQtZ3JhcGhpY3NfMC4xMi4xLnppcCJ9XX1dfQ==
```

If it seems familiar, it's because it's a Base64 encoded JSON string, the same
JSON string returned by the API /mods and /mods/{mod}. Just check whether it's an array
or a single object, and install it.

One thing consider is that the user can click a link to install an specific version, and when
he does, the same mod is encoded, but instead of a list of all versions in the #releases attribute,
it has just the version the user wants to install.

If the user just clicks install, the version to be installed is to be selected by the mod manager.

## How do I submit mods?

Just create an account on the site. After that you'll be able to go to [/mods/new](http://www.factoriomods.com/mods/new) and
create new mods.

If you already published a mod on the Factorio forums, there is high chance that
the mod it's already on the DB. To claim the mod as your own and get management
rights, after you register just send me a [PM me on the forum](http://www.factorioforums.com/forum/ucp.php?i=pm&mode=compose&u=1553)
and I'll transfer you the mod. I'm working on automating this step, but I want to ask for permission
to create an automated bot for the forum first.

## How to get it up and running locally

If you want to contribute you'll probably need to run it locally

```bash
git clone https://github.com/Zequez/FactorioMods
bundle
```

At this point you'll need to configure a Postgres server.

```bash
rake db:setup
rake fake_data
```

That might take a while, specially because `rake fake_data` actually scraps posts from the Factorio forum.

After that you just have to

```bash
rails s
```

And you're on! ...probably... didn't actually test it from scratch on a different
computer, you might need to install some things, I'm sure you'll figure it out!

## Running tests

```bash
bundle exec spring rspec # for one time
guard # for continuous development
```

And you can check if everything it's working on [Travis](https://travis-ci.org/Zequez/FactorioMods).

## Planned features

I just dump all the ideas on [the project Trello board](https://trello.com/b/Ii5IHVxG/factoriomods)

# Copyright / License

Copyright © Ezequiel Adrian Schwartzman. All Rights Reserved.

Licensed under the CPAL-1.0 (the same license that Reddit uses, seemed like a good license for open sourcing web apps).
