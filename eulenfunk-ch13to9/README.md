eulenfunk-ch13to9
=================

this package moves nodes from channel 13 to 9 during initial upgrade.
this is done even if "keep wifi channel" is enabled via UCI

background: some clients (apple) do refuse to connect to channel13, so we
have to move existing nodes. 
This is a onetime-shot operation. 

Not defaulting to the "site.conf" channel but to go to migrate to (static) 9 was done on purpose. 
But having this configurable via the "new site.conf" would be an enhancement. 
(pull requests welcome)


To use the script in your firmware:

```
GLUON_SITE_FEEDS="eulenfunk"
PACKAGES_EULENFUNK_REPO=https://github.com/eulenfunk/packages.git
PACKAGES_EULENFUNK_COMMIT=*/missing/*
PACKAGES_EULENFUNK_BRANCH=v2020.1.x
```

With this done you can add the package `eulenfunk-ch13to9` to your `site.mk`
