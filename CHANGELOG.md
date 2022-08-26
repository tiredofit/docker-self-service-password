## 5.3.0 2022-08-26 <stefandesu@github>

   ### Added
      - Support for Password Complexity Checking


## 5.2.3 2022-06-27 <dave at tiredofit dot ca>

   ### Changed
      - Bug fix to 5.2.2


## 5.2.2 2022-06-23 <dave at tiredofit dot ca>

   ### Added
      - Support tiredofit/nginx:6.0.0 and tiredofit/nginx-php-fpm:7.0.0 changes


## 5.2.1 2022-02-10 <dave at tiredofit dot ca>

   ### Changed
      - Update to support upstream image changes


## 5.2.0 2021-02-11 <arnebjarne@github>

   ### Added
      - LDAP CA Support for AD Authentication


## 5.1.2 2020-07-21 <dave at tiredofit dot ca>

   ### Changed
      - Properly quote variables to allow for multi word strings (such as Mail From Name)


## 5.1.1 2020-06-15 <madmath03@github>

   ### Changed
      - Fixed custom background image not displaying correctly


## 5.1.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.0.0 base image


## 5.0.4 2020-05-10 <ingwarsw@github>

   ## Changed
      - Additional work regarding `SITE_URL` parameter


## 5.0.3 2020-05-08 <ingwarsw@github>

   ## Changed
      - Cleaned up left over references to pre 5.x build relying on templates, notably fixing `SITE_URL` parameter


## 5.0.2 2020-04-08 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup Docker Compose Example
      - Fix to allow spaces in LDAP_BIND_DN, LDAP_BASE_SEARCH, and LDAP_FILTER environment variables


## 5.0.1 2020-02-26 <dave at tiredofit dot ca>

   ### Added
      - Add ability to set SITE_URL environment variable if IS_BEHIND_PROXY=true


## 5.0.0 2020-02-26 <dave at tiredofit dot ca>

   ### Changed
      - Rewrote entire image
      - Added multiple new environment variables
      - Option to run solely off of environment variables without mapping data volumes
      - Option to overwrite files inside image without having to expose source volume
      - Ability to switch to manual configuration mode without requiring all environment variables
      - Set Sane Defaults
      - Cleanup
      
      
## 4.1.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional changes to support new tiredofit/alpine base image


## 4.1.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine base image


## 4.0.1 2019-12-19 <dave at tiredofit dot ca>

   ### Changed
      - Allow for dynamic user/group for nginx


## 4.0 2019-12-06 <dave at tiredofit dot ca>

* Refactored Image to support new tiredofit/nginx-php-fpm image
* PHP 7.3

## 3.1 2019-02-15 <dave at tiredofit dot ca>

* Add USE_TOKENS

## 3.0.1 2019-01-04 <dave at tiredofit dot ca>

* Fix regression with `IS_BEHIND_PROXY`

## 3.0 2019-01-04 <dave at tiredofit dot ca>

* Make version configurable upon Docker build
* Switch to downloading install upon image build for reliability issues
* Cleanup startup script 

## 2.8.1 2019-01-03 <cguentherTUChemnitz@github>

* Fix for missing variable for 2.8 release

## 2.8 2019-01-03 <dave at tiredofit dot ca>

* Add SMTP_AUTOTLS boolean environment variable
* Update Base to PHP 7.2

## 2.7 2018-09-17 <dave at tiredofit dot ca>

* Update to support new features in the local configuration

## 2018-02-01 2.6 <dave at tiredofit dot ca>

* Rebase

## 2017-08-10 2.5 <dave at tiredofit dot ca>

* File Cleanup

## 2017-08-10 2.4 <dave at tiredofit dot ca>

* Added SKIP_MAIL (true/false default false) to be used for webapps/activate-example-org to skip email 
  address confirmation allowing resets to come just by username.

## 2017-08-01 2.3 <dave at tiredofit dot ca>

* Added TOKEN_LIFETIME

## 2017-07-06 2.2 <dave at tiredofit dot ca>

* Added PHP Timeout

## 2017-06-23 2.1 <dave at tiredofit dot ca>

* Sanity Check with s6 scripts

## 2017-06-23 2.0 <dave at tiredofit dot ca>

* Rebase nginx-php-fpm-7.0 with s6.d

## 2017-04-17 1.0 <dave at tiredofit dot ca>
	
* Initial Release
* Alpine:edge
* PHP7
* Based on Git Trunk
