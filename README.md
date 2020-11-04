# hub.docker.com/r/tiredofit/self-service-password

[![Build Status](https://img.shields.io/docker/build/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/self-service-password.svg)](https://hub.docker.com/r/tiredofit/self-service-password)
[![Docker
Layers](https://images.microbadger.com/badges/image/tiredofit/self-service-password.svg)](https://microbadger.com/images/tiredofit/self-service-password)

## Introduction

Dockerfile to build a [LTB-Self Service Password](https://ltb-project.org/documentation/self-service-password) selfservice password manager for LDAP image.

* This Container uses a [customized Alpine Linux base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6 overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier management.

This Container uses [tiredofit/alpine:3.11](https://hub.docker.com/r/tiredofit/alpine) as a base, and [tiredofit/nginx-php-fpm:7.3](https://hub.docker.com/r/tiredofit/nginx-php-fpm) to provide the serving of the content.

[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data-Volumes](#data-volumes)
  - [Environment Variables](#environment-variables)
    - [LDAP Settings](#ldap-settings)
    - [Local Password Policy Settings](#local-password-policy-settings)
    - [Questions Settings](#questions-settings)
    - [Mail Settings](#mail-settings)
    - [Token Settings](#token-settings)
    - [SMS Settings](#sms-settings)
    - [SSH Settings](#ssh-settings)
    - [Recaptcha Settings](#recaptcha-settings)
    - [Misc Application and Branding Settings](#misc-application-and-branding-settings)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

This image assumes that you are using a reverse proxy such as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy Companion @ https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

This image also relies on an external LDAP Server, external SMTP Server.


## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/self-service-password) and is the recommended method of installation.


```bash
docker pull tiredofit/self-service-password:latest
```

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See
the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be
modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this
image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

## Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                         |
| ---------- | ----------------------------------- |
| `/www/ssp` | Root SelfService Password Directory |

*OR*

Don't map anything and let it run with the included source inside the image. If you wish to customize the source on each container restart map the following

| Directory        | Description                                                                                         |
| ---------------- | --------------------------------------------------------------------------------------------------- |
| `/assets/custom` | Place files to be added/updated on container start following the `/www/ssp` file / folder structure |

*OR*

If you want to manually configure the application you can set `SETUP_TYPE=MANUAL` in environment variables and map the following:

| Directory       | Description                 |
| --------------- | --------------------------- |
| `/www/ssp/conf` | SSP Configuration Directory |


### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), the [Nginx Image](https://hub.docker.com/r/tiredofit/nginx), and the [Nginx+PHP-FPM Engine](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter    | Description                                                                                   | Default |
| ------------ | --------------------------------------------------------------------------------------------- | ------- |
| `SETUP_TYPE` | Configure SSP via environment variables `AUTO` or `MANUAL` - If true, ignore everything below | `AUTO`  |

#### LDAP Settings

| Parameter                            | Description                                                                                                                                                                                                                                  | Default                                                   |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `LDAP_SERVER`                        | Ldap server.                                                                                                                                                                                                                                 |                                                           |
| `LDAP_STARTTLS`                      | Enable TLS on Ldap bind.                                                                                                                                                                                                                     |                                                           |
| `LDAP_BINDDN`                        | Ldap bind dn.                                                                                                                                                                                                                                |                                                           |
| `LDAP_BINDPASS`                      | Ldap bind password.                                                                                                                                                                                                                          |                                                           |
| `LDAP_BASE_SEARCH`                   | Base where we can search for users.                                                                                                                                                                                                          |                                                           |
| `LDAP_FILTER`                        | LDAP Lookup Filter                                                                                                                                                                                                                           | `(&(objectClass=person)(\$ldap_login_attribute={login}))` |
| `LDAP_ANSWER_ATTRIBUTE`              | Ldap property to get user's answers if Questions enabled.                                                                                                                                                                                    | `info`                                                    |
| `LDAP_LOGIN_ATTRIBUTE`               | Ldap property used for user searching.                                                                                                                                                                                                       | `uid`                                                     |
| `LDAP_FULLNAME_ATTRIBUTE`            | Ldap property to get user fullname.                                                                                                                                                                                                          | `cn`                                                      |
| `LDAP_MAIL_ATTRIBUTE`                | Ldap property to get user mail.                                                                                                                                                                                                              | `mail`                                                    |
| `LDAP_SMS_ATTRIBUTE`                 | Ldap property to get user SMS Phone Number.                                                                                                                                                                                                  | `mobile`                                                  |
| `LDAP_SSHKEY_ATTRIBUTE`              | Ldap property to get user mail.                                                                                                                                                                                                              | `sshKey`                                                  |
| `AD_OPT_CHANGE_EXPIRED_PASSWORD`     | Allow user with expired password to change password.                                                                                                                                                                                         | `false`                                                   |
| `AD_OPT_FORCE_PWD_CHANGE`            | Force user change password at next login.                                                                                                                                                                                                    | `false`                                                   |
| `AD_OPT_FORCE_UNLOCK`                | Force account unlock when password is changed.  Default to `false`                                                                                                                                                                           |
| `ADMODE`                             | Specifies if LDAP server is Active Directory LDAP server. If your LDAP server is AD, set this to `true`.                                                                                                                                     | `false`                                                   |
| `PASSWORD_HASH_CRYPT_SALT_LENGTH`    | - If `CRYPT` selected what is the hash salt length                                                                                                                                                                                           | `6`                                                       |
| `PASSWORD_HASH_CRYPT_SALT_PREFIX`    | - If `CRYPT` selected what is the hash prefix                                                                                                                                                                                                | `$6$`                                                     |
| `PASSWORD_HASH`                      | Hash mechanism for password`SSHA` `SHA` `SMD5` `MD5` `CRYPT` `clear` (the default) `auto` (will check the hash of current password - if no password existed before, it will set as `clear`)  **This option is not used with ad_mode = true** |
| `QUESTIONS_ANSWER_OBJECTCLASS`       | Default Object Class `extensibleObject`                                                                                                                                                                                                      |
| `SAMBA_EXPIRE_DAYS`                  | Set Password Expiry in Days                                                                                                                                                                                                                  | `90`                                                      |
| `SAMBA_MAX_AGE`                      | Set Password maximum age in AD                                                                                                                                                                                                               | `45`                                                      |
| `SAMBA_MIN_AGE`                      | Set Password minimum age in AD                                                                                                                                                                                                               | `5`                                                       |
| `SAMBA_MODE`                         | Samba mode, if is `true` update sambaNTpassword and the following SAMBA attributes too; if is `false` just update the password.                                                                                                              | `false`                                                   |
| `SHADOW_OPT_UPDATE_SHADOWEXPIRE`     | If `true` update ShadowLastExpire.                                                                                                                                                                                                           | `false`                                                   |
| `SHADOW_OPT_UPDATE_SHADOWLASTCHANGE` | If `true` update shadowLastChange.                                                                                                                                                                                                           | `false`                                                   |

#### Local Password Policy Settings

| Parameter                       | Description                                                                                                              | Default          |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| `PASSWORD_DIFFERENT_LOGIN`      | Should password be different than login                                                                                  | `true`           |
| `PASSWORD_MAX_LENGTH`           | Maximal length.                                                                                                          | `0` (unchecked). |
| `PASSWORD_MIN_DIGIT`            | Minimal digit characters.                                                                                                | `0` (unchecked). |
| `PASSWORD_MIN_LENGTH`           | Minimal length.                                                                                                          | `0` (unchecked). |
| `PASSWORD_MIN_LOWERCASE`        | Minimal lower characters.                                                                                                | `0` (unchecked). |
| `PASSWORD_MIN_SPECIAL`          | Minimal special characters.                                                                                              | `0` (unchecked). |
| `PASSWORD_MIN_UPPERCASE`        | Minimal upper characters.                                                                                                | `0` (unchecked). |
| `PASSWORD_NO_REUSE`             | Dont reuse the same password as currently.                                                                               | `true`.          |
| `PASSWORD_NO_SPECIAL_ENDS`      | Dont allow special characters at start and end of password                                                               | `false`          |
| `PASSWORD_SHOW_POLICY_POSITION` | Position of password policy constraints message `above` `below` | `above`                                                         |
| `PASSWORD_SHOW_POLICY`          | Show policy constraints message`always` `never` `onerror`                                                               | `never`          |
| `PASSWORD_SPECIAL_CHARACTERS`   | Define Special Characters                                                                                                | `^a-zA-Z0-9`     |
| `PASSWORD_USE_PWNED`            | Utilize HaveIbeenpwned.com Password checking service                                                                     | `false`          |
| `WHO_CAN_CHANGE_PASSWORD`       | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. | `user`           |

#### Questions Settings

| Parameter                    | Description                               | Default |
| ---------------------------- | ----------------------------------------- | ------- |
| `USE_QUESTIONS`              | Use questions/answers?  `true` or `false` | `false` |
| `QUESTIONS_ANSWER_CRYPT`     |                                           | `true`  |
| `QUESTIONS_MULTIPLE_ANSWERS` | Allow multiple answers for Questions      | `false` |

#### Mail Settings

| Parameter                 | Description                                                                        | Default                 |
| ------------------------- | ---------------------------------------------------------------------------------- | ----------------------- |
| `MAIL_CHARSET`            | Mail Character set                                                                 | `utf8`                  |
| `MAIL_CONTENTTYPE`        | Content Type Delcaration                                                           | `plain/text`            |
| `MAIL_FROM_NAME`          | Name for `MAIL_FROM`.                                                              | `Self Service Password` |
| `MAIL_FROM`               | Who the email should come from.                                                    | `admin@example.com`     |
| `MAIL_NEWLINE`            | How to address New lines                                                           | `PHP_EOL`               |
| `MAIL_PRIORITY`           | Priority tag of mail                                                               | `3`                     |
| `MAIL_SIGNATURE`          | Mail Signature                                                                     | ``                      |
| `MAIL_USE_LDAP`           | Use first address in LDAP attribute skipping asking for mail                       | `false`                 |
| `MAIL_WORDWRAP`           | Amount of characters to wordwrap email                                             | `80`                    |
| `NOTIFY_ON_CHANGE`        | Notify users anytime their password is changed.                                    | `false`                 |
| `NOTIFY_ON_SSHKEY_CHANGE` | Notify on SSH Key Change                                                           | `true`                  |
| `SMTP_AUTH_ON`            | Force smtp auth with `SMTP_USER` and `SMTP_PASS`.                                  | `false`                 |
| `SMTP_AUTOTLS`            | SMTP Auto TLS `true` or `false`                                                    | `false `                |
| `SMTP_DEBUG`              | SMTP debug mode (following https:////github.com/PHPMailer/PHPMailer instructions). | `0`                     |
| `SMTP_HOST`               | SMTP host.                                                                         |                         |
| `SMTP_KEEPALIVE`          | SMTP Keepalive                                                                     | `false`                 |
| `SMTP_PASS`               | SMTP password.                                                                     |                         |
| `SMTP_PORT`               | SMTP port.                                                                         | `587`                   |
| `SMTP_SECURE_TYPE`        | SMTP secure type to use. `ssl`, `tls` or empty.                                    | `tls`                   |
| `SMTP_TIMEOUT`            | SMTP Timeout in seconds                                                            | `30`                    |
| `SMTP_USER`               | SMTP user.                                                                         |                         |

#### Token Settings

| Parameter        | Description                          | Default |
| ---------------- | ------------------------------------ | ------- |
| `USE_TOKENS`     | Use email to send reset tokens.      | `true`  |
| `TOKEN_CRYPT`    | Encrypt tokens                       | `true`  |
| `TOKEN_LIFETIME` | How long are tokens valid in seconds | `3600`  |

#### SMS Settings

| Parameter                    | Description                      | Default                                 |
| ---------------------------- | -------------------------------- | --------------------------------------- |
| `USE_SMS`                    | Enable sms verification.         | `false`                                 |
| `SMS_API_LIB`                | API Library location for SMS     | `/lib/smsapi.inc.php`                   |
| `SMS_MAIL_SUBJECT`           | Subject for SMS message          | `Provider Code`                         |
| `SMS_MAIL_TO`                | Mail Address                     | `{sms_attribute}@service.provider.com}` |
| `SMS_MESSAGE`                | SMS Message                      | `{snsresetnessae} {smstoken}`           |
| `SMS_METHOD`                 | How to send SMS `mail` or `api`  | `mail`                                  |
| `SMS_PARTIAL_HIDE_NUMBER`    | Partially hide SMS number in     | `true`                                  |
| `SMS_SANITIZE_NUMBER`        | Sanitize non numbers from number | `false`                                 |
| `SMS_TOKEN_LENGTH`           | How many digits for a SMS Code   | `6`                                     |
| `SMS_TRUNCATE_NUMBER_LENGTH` | How many characters for above    | `10`                                    |
| `SMS_TRUNCATE_NUMBER`        | Truncate Characters of number    | `false`                                 |

#### SSH Settings

| Parameter               | Description                                                                                                              | Default |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------- |
| `CHANGE_SSHKEY`         | Enable Changing SSH Key.                                                                                                 | `false` |
| `WHO_CAN_CHANGE_SSHKEY` | Who changes the password?  Also applicable for question/answer save `user`: the user itself `manager`: the above binddn. | `user`  |

#### Recaptcha Settings

| Parameter                  | Description                                             | Default |
| -------------------------- | ------------------------------------------------------- | ------- |
| `USE_RECAPTCHA`            | Use Google reCAPTCHA (http://www.google.com/recaptcha). | `false` |
| `RECAPTCHA_PUB_KEY`        | Go on the site to get public key                        |
| `RECAPTCHA_PRIV_KEY`       | Go on the site to get private key                       |
| `RECAPTCHA_THEME`          | Theme of ReCaptcha. Default: `light`                    |
| `RECAPTCHA_TYPE`           | Type of ReCaptcha Default: `image`                      |
| `RECAPTCHA_SIZE`           | Size of ReCaptcha Default: `small`                      |
| `RECAPTCHA_REQUEST_METHOD` | Special cases                                           | `null`  |

#### Misc Application and Branding Settings

| Parameter                                                   | Description                                                                                                                                         | Default                            |
| ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| `BACKGROUND`                                                | Change background Default `images/unsplash-space.jpg`                                                                                               |
| `DEBUG_MODE`                                                | Debug mode.                                                                                                                                         | `false`                            |
| `DEFAULT_ACTION`                                            | Default action`change` `sendtoken` `sendsms`.                                                                                                       | `change`                           |
| `ENABLE_RESET_LOG` - Write to log detailing password resets | `FALSE`                                                                                                                                             |
| `IS_BEHIND_PROXY`                                           | Enable reset url parameter to accept reverse proxy.                                                                                                 | `false`                            |
| `SITE_URL`                                                  | Use this to hardcode a Site URL if `IS_BEHIND_PROXY=true` - By default it will pull from various HTTP Headers. Example -``https://site.example.com` |
| `LANG`                                                      | Language.                                                                                                                                           | `en`.                              |
| `LOG_LOCATION`                                              | Log Folder                                                                                                                                          | `/www/logs/self-service-password/` |
| `LOG_RESET` - Reset Logfile                                 | `reset.log`                                                                                                                                         |
| `LOGO`                                                      | Main Logo - `Default images/ltb-logo.png`                                                                                                           |
| `SECRETKEY`                                                 | Encryption, decryption keyphrase. Defaults to`secret`                                                                                               |
| `SHOW_HELP`                                                 | Display help messages.                                                                                                                              | `true`.                            |


### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. ssp) bash
```

## References

* https://ltb-project.org/documentation/self-service-password
