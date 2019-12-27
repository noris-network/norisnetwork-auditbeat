# Changelog

All notable changes to this project will be documented in this file.

## Release 0.2.0

**Features**

- moved to latest Puppet Development Kit *PDK 1.15.0.0*
- added service_provider directive
- Puppet 6 compatibility
- allowed major version 7 to be installed
- execute a *apt update* before installing the package for Debian
- added *setup* in configuration for template setup
- improved the repo management

**Bugfixes**

- the repo was replaced with a static URL in a pull request and was replaced with variables afterwards

## Release 0.1.2

**Bugfixes**

- Modified the allowed values for the parameter *service_provider*
- The repo file is created only when *manage_repo* is set to *true* and *ensure* is set to *present*.


## Release 0.1.1

**Features**

- Added support for the configuration of the x-pack monitoring section.


## Release 0.1.0

**Features**

- First implementation.

**Bugfixes**

**Known Issues**

- Only Linux (Debian, CentOS, SuSE Ubuntu) supported
