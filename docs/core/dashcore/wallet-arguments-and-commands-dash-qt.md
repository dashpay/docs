```{eval-rst}
.. _dashcore-arguments-and-commands-dash-qt:
.. meta::
  :title: dash-qt Wallet Arguments and Commands
  :description: The section shows all available options including debug options that are not normally displayed for dash-qt
```

# dash-qt

## Usage

```bash
dash-qt [command-line options]     
```

:::{attention}
The following sections show all available options including debug options that are not normally displayed. To see only regular options, run dash-qt --help.
:::

Dash Core QT GUI includes all the same command line options as [dashd](../dashcore/wallet-arguments-and-commands-dashd.md) with the exception of `-daemon`. It also provides additional options for UI as described below.

### UI Options

```text
  -choosedatadir
       Choose data directory on startup (default: 0)

  -custom-css-dir
       Set a directory which contains custom css files. Those will be used as
       stylesheets for the UI.

  -debug-ui
       Updates the UI's stylesheets in realtime with changes made to the css
       files in -custom-css-dir and forces some widgets to show up which
       are usually only visible under certain circumstances. (default:
       0)

  -font-family
       Set the font family. Possible values: SystemDefault, Montserrat.
       (default: SystemDefault)

  -font-scale
       Set a scale factor which gets applied to the base font size. Possible
       range -100 (smallest fonts) to 100 (largest fonts). (default: 0)

  -font-weight-bold
       Set the font weight for bold texts. Possible range 0 to 8 (default: 4)

  -font-weight-normal
       Set the font weight for normal texts. Possible range 0 to 8 (default: 2)

  -lang=<lang>
       Set language, for example "de_DE" (default: system locale)

  -min
       Start minimized

  -resetguisettings
       Reset all settings changed in the GUI

  -splash
       Show splash screen on startup (default: 1)

  -uiplatform
       Select platform to customize UI for (one of windows, macosx, other;
       default: other)

  -windowtitle=<name>
       Sets a window title which is appended to "Dash Core - "
```
