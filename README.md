# hub.docker.com/tiredofit/self-service-password

# Introduction

Dockerfile to build a [LTB-Self Service Password](https://ltb-project.org/documentation/self-service-password) container image.

It will automatically download the latest release from git.

This Container uses Alpine:3.5 as a base. Additional Components are PHP7 w/ APC, OpCache, LDAP Support


[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy][https://github.com/tiredofit]

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This image relies on an external LDAP Server, external SMTP Server, and is meant to be run behind a reverse SSL Proxy such as nginx-proxy.


# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/self-service-password) and is the recommended method of installation.


```bash
docker pull tiredofit/self-service-password
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See 
the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be 
modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this 
image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

# Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/www/ssp` | Root Wordpress Directory |
| `/www/logs` | Nginx and php-fpm logfiles |

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), and the [Nginx+PHP-FPM Engine](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter | Description |
|-----------|-------------|
| `PHP_MEMORY_LIMIT` |Amount of memory php-fpm process should use (Default 128M) |
| `UPLOAD_MAX_SIZE` | Maximum Upload Size: (Default 2G) |
| `APC_SHM_SIZE` | PHP7 APC SHM Cache Size: (Default 128M) |
| `OPCACHE_MEM_SIZE` | PHP7 OPCache Size (Default 128) |
| `TZ` | Timezone - Use Unix Timezone format (Default America/Vancouver) |
| `DEBUG` | Set this to `true` to enable entrypoint debugging. |
| `LDAP_SERVER` | Ldap server. No default. |
| `LDAP_STARTTLS` | Enable TLS on Ldap bind. No default. |
| `LDAP_BINDDN` | Ldap bind dn. No default. |
| `LDAP_BINDPASS` | Ldap bind password. No default. |
| `LDAP_BASE_SEARCH` | Base where we can search for users. No default. |
| `LDAP_LOGIN_ATTRIBUTE` | Ldap property used for user searching. Defaults to `uid` |
| `LDAP_FULLNAME_ATTRIBUTE` | Ldap property to get user fullname. Defaults to `cn` |
| `ADMODE` | Specifies if LDAP server is Active Directory LDAP server. If your LDAP server is AD, set this to `true`. Defaults to `false`. |
| `AD_OPT_FORCE_UNLOCK` | Force account unlock when password is changed.  Default to `false`.|
| `AD_OPT_FORCE_PWD_CHANGE` | Force user change password at next login.  Defaults to `false`. |
| `AD_OPT_CHANGE_EXPIRED_PASSWORD` | Allow user with expired password to change password. Defaults to `false`. |
| `SAMBA_MODE` | Samba mode, if is `true` update sambaNTpassword and sambaPwdLastSet attributes too; if is `false` just update the password. Defaults to `false`. |
| `SHADOW_OPT_UPDATE_SHADOWLASTCHANGE` | If `true` update shadowLastChange.  Defaults to `false`. |
| `PASSWORD_HASH` |  Hash mechanism for password`SSHA` `SHA` `SMD5` `MD5` `CRYPT` `clear` (the default) `auto` (will check the hash of current password)  **This option is not used with ad_mode = true** |
| `PASSWORD_MIN_LENGTH` | Minimal length. Defaults to `0` (unchecked). |
| `PASSWORD_MAX_LENGTH` | Maximal length. Defaults to `0` (unchecked). |
| `PASSWORD_MIN_LOWERCASE` | Minimal lower characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_UPPERCASE` | Minimal upper characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_DIGIT` | Minimal digit characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_SPECIAL` | Minimal special characters. Defaults to `0` (unchecked).  |
| `PASSWORD_NO_REUSE` | Dont reuse the same password as currently. Defaults to `true`. |
| `PASSWORD_SHOW_POLICY` | Show policy constraints message`always` `never` `onerror`. Defaults to `never` |
| `PASSWORD_SHOW_POLICY_POSITION` | Position of password policy constraints message`above` `below` - 
the form. Defaults to `above` |
| `WHO_CAN_CHANGE_PASSWORD` | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. Defaults to `user` |
| `QUESTIONS_ENABLED` | Use questions/answers?  `true` or `false`. Defaults to `true` |
| `LDAP_MAIL_ATTRIBUTE` | LDAP mail attribute. Defaults to `mail` |
| `MAIL_FROM` | Who the email should come from. Defaults to `admin@example.com` |
| `MAIL_FROM_NAME` | Name for `MAIL_FROM`. Defaults to `No Reply`|
| `NOTIFY_ON_CHANGE` | Notify users anytime their password is changed. Defaults to `false` |
| `SMTP_DEBUG` | SMTP debug mode (following https:////github.com/PHPMailer/PHPMailer instructions). Defaults to `0` |
| `SMTP_HOST` | SMTP host. No default. |
| `SMTP_AUTH_ON` | Force smtp auth with `SMTP_USER` and `SMTP_PASS`. Defaults to `false` |
| `SMTP_USER` | SMTP user. No default. |
| `SMTP_PASS` | SMTP password. No default. |
| `SMTP_PORT` | SMTP port. Defaults to `587` |
| `SMTP_SECURE_TYPE` | SMTP secure type to use. `ssl` or `tls`. Defaults to `tls` |
| `LOGO` | Main Logo - Default images/ltb-logo.png |
| `BACKGROUND` | Change background Default images/unsplash-space.jpg|
| `USE_SMS` | Enable sms notify. (Disabled on this image). Defaults to `false` |
| `IS_BEHIND_PROXY` | Enable reset url parameter to accept reverse proxy. Defaults to `false`  |
| `SHOW_HELP` | Display help messages. Defaults to `true`. |
| `LANG` | Language (NOT WORKING YET). Defaults to `en`.  |
| `DEBUG_MODE` | Debug mode. Defaults to `false`. |
| `SECRETEKEY` | Encryption, decryption keyphrase. Defaults to `secret`. |
| `USE_RECAPTCHA` | Use Google reCAPTCHA (http://www.google.com/recaptcha). Defaults to `false` |
| `RECAPTCHA_PUB_KEY` | Go on the site to get public key |
| `RECAPTCHA_PRIV_KEY` | Go on the site to get private key |
| `RECAPTCHA_THEME` | Theme of ReCaptcha. Default: light|
| `RECAPTCHA_TYPE` | Type of ReCaptcha Default: image|
| `RECAPTCHA_SIZE` | Size of ReCaptcha Default: small|
| `DEFAULT_ACTION` | Default action`change` `sendtoken` `sendsms`. Defaults to `change` |


### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80` | HTTP |

# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. ssp) bash
```

# References

* https://ltb-project.org/documentation/self-service-password



