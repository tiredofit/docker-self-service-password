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
