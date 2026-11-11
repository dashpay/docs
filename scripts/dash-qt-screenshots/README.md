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
| Network | testnet, or regtest with demo data | `-testnet` / `-regtest` |
| Wallet | one wallet loaded, encrypted | |

`settings.json` lives in the network data directory (for example
`~/.dashcore/testnet3/settings.json`). Edit it only while Dash Core is stopped,
and close any open dialog first, otherwise Dash Core does not shut down.

The font weight sliders may sit in different positions on different machines
because their positions depend on which weights the installed font reports. The
rendered text is the same.

### Window size

Sizes below are window contents (no title bar). They are starting points, not
rules. Use a different size when the content needs it, and note why in the commit
message or PR.

- **Retaking an existing screenshot:** resize the window so the capture matches
  the old image's size (`identify old.png`). The figure's `:width:` in the `.rst`
  then still fits and the page layout doesn't change. If the old image includes
  a title bar and the new capture doesn't, subtract its height (about 37 px on
  Ubuntu) instead of leaving an empty band.
- **New main-window shots:** 1064 x 749, the smallest size Dash Core allows on
  an Ubuntu desktop with this profile. Larger shots shrink more on the page.
- **New dialogs:** use the dialog's natural size unless content is cut off or
  hidden behind a scroll bar.
- **Crops** (a single button or a strip of a window): crop from a capture taken
  at one of the sizes above, so the text matches the other screenshots.

Some dialogs ignore Dash Core's font scale and render at the default size,
for example the Proposal Votes dialog, the registration wizard's Review page and
the confirmation pop-ups. That is app behaviour, and it looks the same on a
desktop.

### Window title bars

Desktop captures include the window title bar and a drop shadow. Headless
captures have neither because no window manager runs. Both are fine:

- Keep the title bar if the capture has one. Don't crop it off.
- Don't add one to a capture that doesn't have it.

Following this process keeps the window contents consistent either way.

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

## Scripted capture

Some screenshots can be retaken with scripts in this directory. They need the
packages above (the scripts set up fontconfig, Qt settings and Xvfb themselves)
and a Dash Core build.

```bash
export DASH_BIN=/path/to/dash/bin   # dashd, dash-cli, and dash-qt (or qt/dash-qt)
export WORK=/tmp/dash-qt-screenshots # optional; data and output go here

./setup-demo.sh            # build the regtest demo data (about 15 s)
./capture.sh               # all shots, or name some: capture.sh options wizard
./compare.sh               # what changed against the committed images
./compare.sh --install     # copy the changed images into the repository
```

| Script | What it does |
|---|---|
| `setup-demo.sh` | Builds a regtest chain with a fixed clock (mocktime), wallets from fixed mnemonics, 8 masternodes with fixed BLS keys, 4 proposals and votes. Keeps a pristine copy of it. |
| `capture.sh` | Restores the pristine copy (every run), starts Xvfb, a peer `dashd` and `dash-qt` with the screenshot profile, navigates by fixed window sizes and click coordinates, and writes images to `$WORK/out/<repo path>`. Run `capture.sh --help` for the shot names. |
| `compare.sh` | Compares the images from the latest capture run with the repository, or with another output directory, and lists the share of changed pixels per image. |
| `lib.sh` | Shared settings and helpers. |

What is repeatable:

- Two capture runs on the same demo data give identical images, except the
  wizard's Keys, Review and Save operator key pages. Those show an operator key
  that dash-qt generates at random.
- A new demo data build gives the same addresses, keys, heights, dates and vote
  totals. Masternode payment order (**Last Paid**, **Next Payment**) and
  proposal hashes (Governance tab **Hash** column) depend on transaction hashes
  that include random wallet choices, so they can differ. Rebuild the demo data
  only when you need to; capture runs reuse it.

Limits:

- Coordinates are tied to the window sizes and layout of the Dash Core version
  the shots were written for (v24.0.0). When a release moves a button, update
  the coordinates in `capture.sh`. A changed `compare.sh` result is the signal
  to look.
- The GUI compares the chain tip with the real clock, not mocktime, so it shows
  the sync overlay. `capture.sh` clicks **Hide**. Anything else that uses the
  real clock may differ between days.
- Not scripted yet, take these by hand: the masternode context menu, the
  Proposal Votes dialog, Coin Selection, wallet migration, the splash screen,
  Create Wallet, the wizard's confirm, signing and finished pages (they register
  a masternode, which changes the demo data), and anything that needs v24
  active.

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
  `MASTERNODE_SYNC_FINISHED`, otherwise the GUI shows the sync overlay. If the
  overlay still shows "Syncing Headers" because the tip is old, mine one block.
- Helper wallets created over RPC may not load at the next start. Check with
  `dash-cli listwallets` and load them with `dash-cli loadwallet <name>`. With
  more than one wallet loaded, a wallet selector appears in the tab bar; unload
  helpers before a capture if that matters for the shot.
- To register a masternode from the GUI wallet, one address in it must hold at
  least the collateral amount plus the fee. Otherwise the wizard's **Fee source**
  list is empty.
- Masternodes: `protx register_fund` with an explicit `fundAddress`; without it
  the collateral is spent from the payout address. Keep the owner and voting
  keys in the GUI wallet so **My Votes** and **Owned** have data, and register
  others from a second wallet.
- Proposals: `gobject prepare`, mine 7 blocks, `gobject submit`, then vote with
  `gobject vote-alias`.
- Use documentation IP ranges such as `203.0.113.0/24` for service addresses.
- v24 is an EHF deployment. By default it activates only after a masternode
  quorum signs an activation signal, which a regtest with registered but not
  running masternodes can't produce. Until then **Shared Masternode…** stays
  disabled and the wizard shows its pre-v24 pages (for example Platform ports
  instead of Platform addresses). Regtest's debug option
  `-vbparams=v24:<start>:<end>:<min_height>:<window>:<thresholdstart>:<thresholdmin>:<falloffcoeff>:0`
  (last field `useehf=0`) should turn it into an ordinary miner-signalled
  deployment, but this is untested. Shared masternodes may also depend on the
  separate `evo_shares` deployment. Use a copy of the demo data directory, and
  give the peer the same option.

### Special cases

- **Splash screen:** start a throwaway mainnet instance with its own data
  directory (`-prune=945 -connect=0 -nowallet`). Startup is too fast to catch
  with screenshots alone. One approach that worked: dismiss the startup warning,
  then freeze the process with `kill -STOP <pid>` a few hundredths of a second
  later (about 0.04 s), capture, and `kill -CONT` or kill it. Adjust the delay
  until the frame shows a status message and a partly filled bar. Without a
  compositor the rounded corners render black; make them transparent with an
  ImageMagick floodfill from each corner.
- **Tall dialogs (Register Masternode wizard):** the wizard pages put the buttons
  at the bottom of a mostly empty page. Capture at a fixed width (640 px was used
  for the v24 pages) and a height that shows all the content without a scroll
  bar (900 px for most pages, 1080 px for Review). Then cut out the empty space,
  keeping the content, a small margin (24 px) and the bottom button row (64 px).
  Use the same width for every page of one dialog.
