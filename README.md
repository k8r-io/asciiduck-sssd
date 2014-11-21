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

Currently this module only supports RHEL/CentOS 7 and Ubuntu 14.04; however, 
if you specify the needed parameters yourself you can override the "unsupported 
os" failure.

## Usage

Incoming


## Development

If you would like to contribute, just go through the standard:
* Fork
* Feature branch
* Pull Request
