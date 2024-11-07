```{eval-rst}
.. meta::
  :title: Removed RPCs
  :description: A list of RPCs that have recently been removed from Dash Core.
```

# Removed RPCs

The following RPCs were recently removed. See the [previous version of documentation](https://docs.dash.org/projects/core/en/20.0.0/docs/api/remote-procedure-calls-removed.html) for RPCs removed longer ago.

## GObject Vote-conf

:::{attention}
Removed in Dash Core 20.0.0
:::

The `gobject vote-conf` RPC votes on a governance object by masternode configured in dash.conf.

*Parameter #1---governance hash*

| Name              | Type         | Presence                | Description                   |
| ----------------- | ------------ | ----------------------- | ----------------------------- |
| `governance-hash` | string (hex) | Required<br>(exactly 1) | Hash of the governance object |

*Parameter #2---vote signal*

| Name     | Type   | Presence                | Description                                  |
| -------- | ------ | ----------------------- | -------------------------------------------- |
| `signal` | string | Required<br>(exactly 1) | Vote signal: `funding`, `valid`, or `delete` |

*Parameter #3---vote outcome*

| Name      | Type   | Presence                | Description                             |
| --------- | ------ | ----------------------- | --------------------------------------- |
| `outcome` | string | Required<br>(exactly 1) | Vote outcome: `yes`, `no`, or `abstain` |

*Result---votes for specified governance*

| Name               | Type   | Presence                | Description                               |
| ------------------ | ------ | ----------------------- | ----------------------------------------- |
| Result             | object | Required<br>(exactly 1) | The governance object votes               |
| →<br>`overall`     | string | Required<br>(1 or more) | Reports number of vote successes/failures |
| →<br>`detail`      | object | Required<br>(exactly 1) | Vote details                              |
| → →<br>`dash.conf` | object | Required<br>(1 or more) |                                           |
| → → →<br>`result`  | string | Required<br>(exactly 1) | Vote result                               |

*Example from Dash Core 0.12.2*

``` bash
dash-cli -testnet gobject vote-conf \
0bf97bce78b3b642c36d4ca8e9265f8f66de8774c220221f57739c1956413e2b funding yes
```

``` json
{
  "overall": "Voted successfully 1 time(s) and failed 0 time(s).",
  "detail": {
    "dash.conf": {
      "result": "success"
    }
  }
}
```

## Protx

### ProTx Register HPMN

:::{attention}
Removed in Dash Core 22.0.0
:::

The `protx *_hpmn` RPC commands were renamed and deprecated in Dash Core 20.0.0. They can now be accessed as `protx *_evo` (e.g., `protx register_hpmn` is now [`protx register_evo`](../api/remote-procedure-calls-evo.md#protx-register-evo)).

**All `protx *_hpmn` RPC commands were removed in Dash Core 22.0.0.**

### ProTx Register Fund HPMN

:::{attention}
Removed in Dash Core 22.0.0
:::

The `protx *_hpmn` RPC commands were renamed and deprecated in Dash Core 20.0.0. They can now be accessed as `protx *_evo` (e.g., `protx register_hpmn` is now [`protx register_evo`](../api/remote-procedure-calls-evo.md#protx-register-evo)).

**All `protx *_hpmn` RPC commands were removed in Dash Core 22.0.0.**

### ProTx Register Prepare HPMN

:::{attention}
Removed in Dash Core 22.0.0
:::

The `protx *_hpmn` RPC commands were renamed and deprecated in Dash Core 20.0.0. They can now be accessed as `protx *_evo` (e.g., `protx register_hpmn` is now [`protx register_evo`](../api/remote-procedure-calls-evo.md#protx-register-evo)).

**All `protx *_hpmn` RPC commands were removed in Dash Core 22.0.0.**

### ProTx Update Service HPMN

:::{attention}
Removed in Dash Core 22.0.0
:::

The `protx *_hpmn` RPC commands were renamed and deprecated in Dash Core 20.0.0. They can now be accessed as `protx *_evo` (e.g., `protx register_hpmn` is now [`protx register_evo`](../api/remote-procedure-calls-evo.md#protx-register-evo)).

**All `protx *_hpmn` RPC commands were removed in Dash Core 22.0.0.**
