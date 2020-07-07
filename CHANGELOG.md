# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v0.2.5](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.5) (2020-06-07)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.2.1...v0.2.5)

# Added

- added **update README.md**

## [v0.2.4](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.4) (2020-06-07)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.2.1...v0.2.5)

# Added

- added **support for additional configuration keys** 
- Puppet version 4 testing removed

## [v0.2.3](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.3) (2020-04-07)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.2.1...v0.2.3

## [v0.2.2](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.2) (2020-01-24)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.2.1...v0.2.2)

# Added

- added **monitoring** Hash for new elastic major version 7 and 8
- added **$gpg_key_id** to repo.pp variables in case of elastic wants to change the gpg key some time
- added **Puppet version 4 testing** since PDK does not test puppet 4

# Fixed

- fixed typo in **metadata.json**
- improved **dependencies versions** in metadata.json for stdlib and apt


## [v0.2.1](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.1) (2020-01-10)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.2.0...v0.2.1)

### Added

- added possibility to install major version **5** additional to already configured versions **6** and **7**
- changed default major version from **6** to **7**
- added **$apt_repo_url**, **$yum_repo_url** and **$gpg_key_url** variables to enhance repo management
- enhanced repo management itself by better variable management
- updated spec tests to elastic major version **7** instead of major version **6** tests

### Fixed

- **.fixtures** updated and yaml structure fixed
- **.vscode** folder readded to repo and removed from **.gitignore** since it is a part of the current pdk
- removed **.project** file since it is a part of **.gitignore** now
- switched from github pdk template to default pdk template

## [v0.2.0](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.2.0) (2019-12-27)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.1.2...v0.2.0)

### Added

- switched to latest Puppet Development Kit **PDK 1.15.0.0**
- added service_provider directive
- Puppet 6 compatibility
- allowed major version 7 to be installed
- execute a *apt update* before installing the package for Debian
- added *setup* in configuration for template setup
- improved the repo management

### Fixed

- the repo was replaced with a static URL in a pull request and was replaced with variables afterwards

## [v0.1.2](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.1.2) (2019-12-27)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.1.1...v0.1.2)

### Fixed

- Modified the allowed values for the parameter *service_provider*
- The repo file is created only when *manage_repo* is set to *true* and *ensure* is set to *present*.


## [v0.1.1](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.1.1) (2018-06-20)

[Full Changelog](https://github.com/noris-network/norisnetwork-auditbeat/compare/v0.1.0...v0.1.1)

### Added

- Added support for the configuration of the x-pack monitoring section.

## [v0.1.0](https://github.com/noris-network/norisnetwork-auditbeat/tree/v0.1.0) (2018-06-11)

### Added

- First implementation.

### Known issues

- Only Linux (Debian, CentOS, SuSE Ubuntu) supported
