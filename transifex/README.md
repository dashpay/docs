# Transifex

Transifex is used to support multiple languages. The scripts in this folder
assist with pushing data for translators to Transifex and retrieving translated
information.

## Install required packages

Install the [sphinx-intl](https://pypi.org/project/sphinx-intl/) utility.

```shell
pip install sphinx-intl==2.1.0
```

Also install the Transifex CLI client as described in the [repository's
README](https://github.com/transifex/cli/tree/devel#transifex-client).

``` shell
curl -o- https://raw.githubusercontent.com/transifex/cli/master/install.sh | bash
```

## Set webhook variables

The `build.sh` script requires Transifex webhook token and URL values. These
should be defined in a `.env` file. See [.env.example](.env.example) for an
example of the format.

## Usage

Using the scripts requires adding a Transifex API token to an account that has
access to the project as mention in the [Transifex client documentation](https://docs.transifex.com/client/introduction#authenticating).

It is also necessary to add authorization information in a `.transifexrc` file
as shown in this example:

```text
[https://www.transifex.com]
api_hostname = https://api.transifex.com
hostname = https://www.transifex.com
password = <enter password generated on https://www.transifex.com/user/settings/api/ here>
username = api
```

### To upload to Transifex

Run the following from the root of the project to upload to Transifex:

``` bash
./transifex/pushtx.sh
```

### To retrieve from Transifex

Next run the following to retrieve the translation updates:

``` bash
./transifex/pulltx.sh
```

### To build localized sites

Make sure the webhook variables are accessible. Run the following in the folder
containing your `.env` file:

``` bash
source .env
```

Next run the following to trigger builds for each language on ReadTheDocs:

``` bash
./transifex/build.sh
```

### To check build status for localized sites

Make sure the [token](https://docs.readthedocs.io/en/stable/api/v3.html#token) variable is accessible. Run the following in the folder containing your `.env`
file:

``` bash
source .env
```

Next run the following to check build status for each language on ReadTheDocs:

``` bash
./transifex/build-status-check.sh
```

## Building localized sites locally

To test localized sites offline, use sphinx-build with the `language` parameter set to one of the
language codes (see the `locale` folder for available languages):

``` bash
sphinx-build -b html -D language='zh_CN' . _build/html/zh_CN
```
