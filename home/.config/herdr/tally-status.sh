#!/bin/sh
# Herdr tab-bar entry: remaining Tally credits for the month.
# Wired via ui.tab_bar_right in ~/.config/herdr/config.toml.
set -eu
"$HOME/.config/gohan/bin/tally" usage --json | /usr/bin/jq -r '
  def fmt: floor | tostring | until(test("^\\d{4}"; "") | not; sub("(?<a>\\d)(?<b>\\d{3})(?<c>,|$)"; "\(.a),\(.b)\(.c)"));
  (.monthlyLimitCredits - .monthlyCredits) as $left
  | "tally \($left | fmt) left (\(100 * $left / .monthlyLimitCredits | floor)%) · today \(.todayCredits | fmt)"
'
