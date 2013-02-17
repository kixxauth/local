if [[ ! -o interactive ]]; then
    return
fi

compctl -K _ksys ksys

_ksys() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(ksys commands)"
  else
    completions="$(ksys completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
