# sssd

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Development - Guide for contributing to the module](#development)

## Overview

SSSD is the replacement for nslcd that is the default in CentOS and RHEL 7.


## Module Description

This module will install, configure and manage the SSSD service, but it will
not touch your nsswitch or your pam configs, that's the job for another module.

Currently this module only supports RHEL/CentOS 7, Ubuntu 14.04, Debian 8.x; however, 
if you specify the needed parameters yourself you can override the "unsupported 
os" failure.

Previously this module would install the sudo package on Debian based platforms which
replaced the package sudo-ldap. It was decided that the decision of which sudo package
to use was out of scope of this module. If you are seeing issues with sudo and sssd 
on Ubuntu 14.04 or Debian 8.x ensure you have sudo installed and not sudo-ldap.

## Usage

Incoming


## Development

If you would like to contribute, just go through the standard:
* Fork
* Feature branch
* Pull Request
