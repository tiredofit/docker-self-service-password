# hub.docker.com/r/tiredofit/self-service-password

[![Build Status](https://img.shields.io/docker/build/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker 
Layers](https://images.microbadger.com/badges/image/tiredofit/self-service-password.svg)](https://microbadger.com/images/tiredofit/self-service-password)

# Introduction

Dockerfile to build a [LTB-Self Service Password](https://ltb-project.org/documentation/self-service-password) selfservice password manager for LDAP image.

* This Container uses a [customized Alpine Linux base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management.

This Container uses [tiredofit/alpine:3.11](https://hub.docker.com/r/tiredofit/alpine as a base, and [tiredofit/nginx-php-fpm:7.3](https://hub.docker.com/r/tiredofit/nginx-php-fpm) to provide the serving of the content.

[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit)

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

This image assumes that you are using a reverse proxy such as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy Companion @ https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

This image also relies on an external LDAP Server, external SMTP Server.


# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/self-service-password) and is the recommended method of installation.


```bash
docker pull tiredofit/self-service-password:latest
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
| `/www/ssp` | Root SelfService Password Directory |

*OR*

Don't map anything and let it run with the included source inside the image. If you wish to customize the source on each container restart map the following

| Directory | Description |
|-----------|-------------|
| `/assets/custom` | Place files to be added/updated on container start following the `/www/ssp` file / folder structure

*OR* 

If you want to manually configure the application you can set `SETUP_TYPE=MANUAL` in environment variables and map the following:

| Directory | Description |
|-----------|-------------|
| `/www/ssp/conf` | SSP Configuration Directory |


### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), the [Nginx Image](https://hub.docker.com/r/tiredofit/nginx), and the [Nginx+PHP-FPM Engine](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter | Description |
|-----------|-------------|
| `SETUP_TYPE` | Configure SSP via environment variables `TRUE` or `FALSE` - If true, ignore everything below |

#### LDAP Settings

| Parameter | Description |
|-----------|-------------|
| `LDAP_SERVER` | Ldap server. No default. |
| `LDAP_STARTTLS` | Enable TLS on Ldap bind. No default. |
| `LDAP_BINDDN` | Ldap bind dn. No default. |
| `LDAP_BINDPASS` | Ldap bind password. No default. |
| `LDAP_BASE_SEARCH` | Base where we can search for users. No default. |
| `LDAP_FILTER` | LDAP Lookup Filter - Default `(&(objectClass=person)(\$ldap_login_attribute={login}))` |
| `LDAP_ANSWER_ATTRIBUTE` | Ldap property to get user's answers if Questions enabled. Defaults to `info` |
| `LDAP_LOGIN_ATTRIBUTE` | Ldap property used for user searching. Defaults to `uid` |
| `LDAP_FULLNAME_ATTRIBUTE` | Ldap property to get user fullname. Defaults to `cn` |
| `LDAP_MAIL_ATTRIBUTE` | Ldap property to get user mail. Defaults to `mail` |
| `LDAP_SMS_ATTRIBUTE` | Ldap property to get user SMS Phone Number. Defaults to `mobile` |
| `LDAP_SSHKEY_ATTRIBUTE` | Ldap property to get user mail. Defaults to `sshKey` |
| `AD_OPT_CHANGE_EXPIRED_PASSWORD` | Allow user with expired password to change password. Defaults to `false`. |
| `AD_OPT_FORCE_PWD_CHANGE` | Force user change password at next login.  Defaults to `false`. |
| `AD_OPT_FORCE_UNLOCK` | Force account unlock when password is changed.  Default to `false`.|
| `ADMODE` | Specifies if LDAP server is Active Directory LDAP server. If your LDAP server is AD, set this to `true`. Defaults to `false`. |
| `PASSWORD_HASH_CRYPT_SALT_LENGTH` | - If `CRYPT` selected what is the hash salt length - Default `6` |
| `PASSWORD_HASH_CRYPT_SALT_PREFIX` | - If `CRYPT` selected what is the hash prefix - Default `$6$` |
| `PASSWORD_HASH` |  Hash mechanism for password`SSHA` `SHA` `SMD5` `MD5` `CRYPT` `clear` (the default) `auto` (will check the hash of current password - if no password existed before, it will set as `clear`)  **This option is not used with ad_mode = true** |
| `QUESTIONS_ANSWER_OBJECTCLASS` | Default Object Class `extensibleObject` |
| `SAMBA_EXPIRE_DAYS` | Set Password Expiry in Days - Default `90` |
| `SAMBA_MAX_AGE` | Set Password maximum age in AD - Default `45` |
| `SAMBA_MIN_AGE` | Set Password minimum age in AD - Default `5` |
| `SAMBA_MODE` | Samba mode, if is `true` update sambaNTpassword and the following SAMBA attributes too; if is `false` just update the password. Defaults to `false`. |
| `SHADOW_OPT_UPDATE_SHADOWEXPIRE | If `true` update ShadowLastExpire. Defaults to `false` 
| `SHADOW_OPT_UPDATE_SHADOWLASTCHANGE` | If `true` update shadowLastChange.  Defaults to `false`. |

#### Local Password Policy Settings

| Parameter | Description |
|-----------|-------------|
the form. Defaults to `above` |
| `PASSWORD_DIFFERENT_LOGIN` | Should password be different than login - Default `true`
| `PASSWORD_MAX_LENGTH` | Maximal length. Defaults to `0` (unchecked). |
| `PASSWORD_MIN_DIGIT` | Minimal digit characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_LENGTH` | Minimal length. Defaults to `0` (unchecked). |
| `PASSWORD_MIN_LOWERCASE` | Minimal lower characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_SPECIAL` | Minimal special characters. Defaults to `0` (unchecked).  |
| `PASSWORD_MIN_UPPERCASE` | Minimal upper characters. Defaults to `0` (unchecked).  |
| `PASSWORD_NO_REUSE` | Dont reuse the same password as currently. Defaults to `true`. |
| `PASSWORD_NO_SPECIAL_ENDS` | Dont allow special characters at start and end of password - Default `false` |
| `PASSWORD_SHOW_POLICY_POSITION` | Position of password policy constraints message`above` `below` - 
| `PASSWORD_SHOW_POLICY` | Show policy constraints message`always` `never` `onerror`. Defaults to `never` |
| `PASSWORD_SPECIAL_CHARACTERS` | Define Special Characters - Default `^a-zA-Z0-9` |
| `PASSWORD_USE_PWNED` | Utilize HaveIbeenpwned.com Password checking service - Default `false`
| `WHO_CAN_CHANGE_PASSWORD` | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. Defaults to `user` |

#### Questions Settings

| Parameter | Description |
|-----------|-------------|
| `USE_QUESTIONS` | Use questions/answers?  `true` or `false`. Defaults to `false` |
| `QUESTIONS_ANSWER_CRYPT` | Default `true` |
| `QUESTIONS_MULTIPLE_ANSWERS | Allow multiple answers for Questions - Default - `false` |

#### Mail Settings

| Parameter | Description |
|-----------|-------------|
| `MAIL_CHARSET` | Mail Character set - Default `utf8` |
| `MAIL_CONTENTTYPE` | Content Type Delcaration | - Default `plain/text` |
| `MAIL_FROM_NAME` | Name for `MAIL_FROM`. Defaults to `Self Service Password`|
| `MAIL_FROM` | Who the email should come from. Defaults to `admin@example.com` |
| `MAIL_NEWLINE` | How to address New lines - Default `PHP_EOL` |
| `MAIL_PRIORITY` | Priority tag of mail - Default `3` |
| `MAIL_SIGNATURE` | Mail Signature - Default `` |
| `MAIL_USE_LDAP` | Use first address in LDAP attribute skipping asking for mail - Default `false` |
| `MAIL_WORDWRAP` | Amount of characters to wordwrap email - Default `80` |
| `NOTIFY_ON_CHANGE` | Notify users anytime their password is changed. Defaults to `false` |
| `NOTIFY_ON_SSHKEY_CHANGE` | Notify on SSH Key Change - Default `true` |
| `SMTP_AUTH_ON` | Force smtp auth with `SMTP_USER` and `SMTP_PASS`. Defaults to `false` |
| `SMTP_AUTOTLS` | SMTP Auto TLS `true` or `false`. Defaults to `false ` |
| `SMTP_DEBUG` | SMTP debug mode (following https:////github.com/PHPMailer/PHPMailer instructions). Defaults to `0` |
| `SMTP_HOST` | SMTP host. No default. |
| `SMTP_KEEPALIVE` | SMTP Keepalive - Default `false` |
| `SMTP_PASS` | SMTP password. No default. |
| `SMTP_PORT` | SMTP port. Defaults to `587` |
| `SMTP_SECURE_TYPE` | SMTP secure type to use. `ssl` or `tls`. Defaults to `tls` |
| `SMTP_TIMEOUT` | SMTP Timeout in seconds - Default `30` |
| `SMTP_USER` | SMTP user. No default. |

#### Token Settings

| Parameter | Description |
|-----------|-------------|
| `USE_TOKENS` | Use email to send reset tokens. Defaults to `true` |
| `TOKEN_CRYPT` | Encrypt tokens - Default `true` |
| `TOKEN_LIFETIME` | How long are tokens valid in seconds - Default `3600` | 

#### SMS Settings

| Parameter | Description |
|-----------|-------------|
| `USE_SMS` | Enable sms verification. Defaults to `false` |
| `SMS_API_LIB` | API Library location for SMS - Default `/lib/smsapi.inc.php` |
| `SMS_MAIL_SUBJECT` | Subject for SMS message - Default `Provider Code` |
| `SMS_MAIL_TO` | Mail Address - Default `{sms_attribute}@service.provider.com}` |
| `SMS_MESSAGE` | SMS Message - Default `{snsresetnessae} {smstoken}` |
| `SMS_METHOD` | How to send SMS `mail` or `api` - Default `mail` |
| `SMS_PARTIAL_HIDE_NUMBER` | Partially hide SMS number in - Default `true` |
| `SMS_SANITIZE_NUMBER` | Sanitize non numbers from number - Default `false` |
| `SMS_TOKEN_LENGTH` | How many digits for a SMS Code - Default `6` |
| `SMS_TRUNCATE_NUMBER_LENGTH` | How many characters for above - Default `10` |
| `SMS_TRUNCATE_NUMBER` | Truncate Characters of number - Default `false` |

#### SSH Settings

| Parameter | Description |
|-----------|-------------|
| `CHANGE_SSHKEY` | Enable Changing SSH Key. Defaults to `false` |

| `WHO_CAN_CHANGE_SSHKEY` | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. Defaults to `user` |

#### Recaptcha Settings

| Parameter | Description |
|-----------|-------------|
| `USE_RECAPTCHA` | Use Google reCAPTCHA (http://www.google.com/recaptcha). Defaults to `false` |
| `RECAPTCHA_PUB_KEY` | Go on the site to get public key |
| `RECAPTCHA_PRIV_KEY` | Go on the site to get private key |
| `RECAPTCHA_THEME` | Theme of ReCaptcha. Default: `light`|
| `RECAPTCHA_TYPE` | Type of ReCaptcha Default: `image` |
| `RECAPTCHA_SIZE` | Size of ReCaptcha Default: `small` |
| `RECAPTCHA_REQUEST_METHOD` | Special cases - Default `null` |

#### Misc Application and Branding Settings

| Parameter | Description |
|-----------|-------------|
| `BACKGROUND` | Change background Default `images/unsplash-space.jpg` |
| `DEBUG_MODE` | Debug mode. Defaults to `false`. |
| `DEFAULT_ACTION` | Default action`change` `sendtoken` `sendsms`. Defaults to `change` |
| `ENABLE_RESET_LOG` - Write to log detailing password resets - Default `FALSE` |
| `IS_BEHIND_PROXY` | Enable reset url parameter to accept reverse proxy. Defaults to `false`  |
| `LANG` | Language. Defaults to `en`.  |
| `LOG_LOCATION` - Log Folder - Default `/www/logs/self-service-password/` |
| `LOG_RESET` - Reset Logfile - Default `reset.log` |
| `LOGO` | Main Logo - `Default images/ltb-logo.png` |
| `SECRETKEY` | Encryption, decryption keyphrase. Defaults to`secret` |
| `SHOW_HELP` | Display help messages. Defaults to `true`. |


### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80`      | HTTP        |

# Maintenance
#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. ssp) bash
```

# References

* https://ltb-project.org/documentation/self-service-password
