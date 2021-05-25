# Transifex

Transifex is used to support multiple languages. The scripts in this folder
assist with pushing data for translators to Transifex and retrieving translated
information.

## Install required packages

``` shell
pip install sphinx-intl
pip install transifex-client==0.13.12
```

## Webhook variables

The `pulltx.sh` script requires Transifex webhook token and URL values. These
should be defined in a `.env` file. See [.env.example](.env.example) for an
example of the format.

## To upload to Transifex

Run the following from the root of the project to upload to Transifex:

``` bash
./transifex/pushtx.sh
```

## To retrieve from Transifex and update site

Make sure the webhook variables are accessible. Run the following in the folder
containing your `.env` file:

``` bash
source .env
```

Next run the following to retrieve the translation updates:

``` bash
./transifex/pulltx.sh
```
