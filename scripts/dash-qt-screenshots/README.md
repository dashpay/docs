# Dash Core (dash-qt) screenshots

How to take Dash Core GUI screenshots for `docs/user/` so they look the same
whether they were captured on a maintainer's Ubuntu desktop or headless (for
example in an agent sandbox).

## Screenshot profile

Use these settings for every new or retaken Dash Core screenshot.

| Setting | Value | Where |
|---|---|---|
| System font | Ubuntu Sans (Ubuntu 24.04 default) | OS / fontconfig |
| Theme | Light | Options > Appearance |
| Font Family | SystemDefault | Options > Appearance |
| Font Scale | -30 (slider fully left) | `settings.json`: `"font-scale": -30` |
| Font Weight Normal | 3 (Regular) | `settings.json`: `"font-weight-normal": 3` |
| Font Weight Bold | 6 (Bold) | `settings.json`: `"font-weight-bold": 6` |
| Font in the Overview tab | Use existing font | Options > Appearance |
| Locale | `en_US.UTF-8` (dates such as `11/10/26`) | `LANG` |
| Font DPI | 96 | `QT_FONT_DPI=96` |
| Main window size | 1064 x 749 (window contents) | resize before capture |
| Options dialog size | 632 x 480 (window contents) | resize before capture |
| Network | testnet, or regtest with demo data | `-testnet` / `-regtest` |
| Wallet | one wallet loaded, encrypted | |

`settings.json` lives in the network data directory (for example
`~/.dashcore/testnet3/settings.json`). Edit it only while Dash Core is stopped,
and close any open dialog first, otherwise Dash Core does not shut down.

The font weight sliders may sit in different positions on different machines
because their positions depend on which weights the installed font reports. The
rendered text is the same.

Main-window shots wider than the minimum shrink a lot on the page. Keep the main
window at 1064 x 749 unless the screen needs more room.

### Open decision: window title bars

Desktop captures include the window title bar and a drop shadow. Headless
captures have neither because no window manager runs. Not decided yet:

- crop every screenshot to the window contents (matches everywhere,
  theme-neutral), or
- keep title bars (only desktop captures, or a window manager that approximates
  the Ubuntu theme).

Until this is decided, headless captures are contents-only.

## Headless setup (Ubuntu, no desktop)

```bash
sudo apt-get install --no-install-recommends \
  xvfb xauth fonts-ubuntu fontconfig imagemagick xdotool locales
sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

# Make Ubuntu Sans the default UI font (Qt's SystemDefault comes from fontconfig)
mkdir -p ~/.config/fontconfig
cat > ~/.config/fontconfig/fonts.conf <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias binding="strong"><family>sans-serif</family><prefer><family>Ubuntu Sans</family></prefer></alias>
  <alias binding="strong"><family>Sans Serif</family><prefer><family>Ubuntu Sans</family></prefer></alias>
</fontconfig>
EOF
fc-cache -f

Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp &
DISPLAY=:99 LANG=en_US.UTF-8 QT_FONT_DPI=96 dash-qt -regtest -datadir=<dir> &
```

The static dash-qt build only has the `xcb` Qt platform plugin, so it needs an
X display (Xvfb) even for `dash-qt -help`.

### Driving the GUI

- Find windows with `xdotool search --onlyvisible --name ''` and
  `xdotool getwindowname <id>`.
- Without a window manager, place and size windows yourself:
  `xdotool windowmove <id> 0 0 windowsize <id> 1064 749`.
- Run `xdotool windowfocus <id>` before clicking a button that opens a dialog.
  Otherwise the click is often ignored. For menu items, use a separate
  `mousedown` and `mouseup`, or the keyboard mnemonics (`alt+s`, then `o` for
  Settings > Options).
- Capture one window with `import -window <id> out.png`.

### Regtest demo data

- Use a `dash.conf` with `rpcuser`/`rpcpassword`, and a second `dashd` peer so
  the status bar doesn't show "Connecting to peers…".
- Mine past height 650 so DIP3 is active.
- After each start, run `mnsync next` until the status is
  `MASTERNODE_SYNC_FINISHED`, otherwise the GUI shows the sync overlay.
- Masternodes: `protx register_fund` with an explicit `fundAddress`; without it
  the collateral is spent from the payout address. Keep the owner and voting
  keys in the GUI wallet so **My Votes** and **Owned** have data, and register
  others from a second wallet.
- Proposals: `gobject prepare`, mine 7 blocks, `gobject submit`, then vote with
  `gobject vote-alias`.
- Use documentation IP ranges such as `203.0.113.0/24` for service addresses.
- The v24 fork can't activate on a single-node regtest (it needs an EHF quorum
  signal), so **Shared Masternode…** stays disabled there.

### Special cases

- **Splash screen:** start a throwaway mainnet instance
  (`-prune=945 -connect=0 -nowallet`), dismiss the startup warning, and capture
  frames in a fast loop. Without a compositor the rounded corners render black;
  make them transparent with an ImageMagick floodfill from each corner.
- **Tall dialogs (Register Masternode wizard):** capture at 760 x 1060, then cut
  out the empty space between the content and the bottom button row.
