# Dash Docs

[![Build
status](https://img.shields.io/readthedocs/dash-docs/stable)](https://readthedocs.org/projects/dash-docs/builds/)
[![standard-readme
compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen)](https://github.com/RichardLitt/standard-readme)

Dash User Documentation

The official Dash documentation is oriented towards the average user and serves to describe all
aspects of the Dash ecosystem, ranging from information for new users through to guides on more
difficult tasks such as maintaining a masternode. User documentation (this repository) is hosted at
https://docs.dash.org. Core developer documentation is found at https://docs.dash.org/core ([source
repository](https://github.com/dashpay/docs-core)) and Platform developer documentation is at
https://docs.dash.org/platform ([source repository](https://github.com/dashpay/docs-platform)).

## Usage

If you have Python installed, you can download this repository and build the documentation locally.
Python 3.13 is recommended since the hosted documentation is built with that version. The following
instructions are based on Ubuntu 22.04.

1. Set up and activate a Python virtual environment to isolate the documentation by running this
   command from the root of the project:

    ```shell
    python3.13 -m venv venv/
    source ./venv/bin/activate
    ```

1. Install the dependencies need to build the documentation:

    ```shell
    pip install -r requirements.txt
    ```

1. Build the documentation:

    ```shell
    make html
    ```

1. If you modify any pages, rebuild the documentation before attempting to preview the changes:

    ```shell
    rm -r _build/ || true && make html
    ```

The documentation will be located in the `_build/html` directory and can be viewed by opening
`_build/html/index.html` in a browser. Note: the standard search functionality is not available for
locally built documentation.

## Contributing

This documentation is written in [reStructuredText](https://docutils.sourceforge.io/rst.html) and is
designed to be built with [Sphinx](https://www.sphinx-doc.org/) and hosted by [Read the
Docs](https://readthedocs.org/). Feel free to [open an
issue](https://github.com/dashpay/docs/issues/new/choose) or submit PRs modifying the English source
text in this repository. Contributions to translations of the source text are welcomed on
[Transifex](https://www.transifex.com/dash/dash-docs/).

### Package management

Packages are managed using [pip-tools](https://pip-tools.readthedocs.io/en/latest/). Install it
using:

```shell
pip install pip-tools
```

#### Add packages

To include a new package:

1. Add the package to `requirements.in`
1. Run `pip-compile` to update `requirements.txt`
1. Run `pip install -r requirements.txt` to install all packages

#### Update packages

Specific packages can be updated using `pip-compile --upgrade-package <package name>`. To [update
all packages](https://pip-tools.readthedocs.io/en/latest/#updating-requirements):

1. Run `pip-compile --upgrade`

## License

[MIT](/LICENSE) © Dash Core Group, Inc.
