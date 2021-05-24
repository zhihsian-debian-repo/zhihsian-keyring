#!/bin/sh
# Looks for revoked keys in our active keyrings
set -e

find_revoked () {
	k=$1
	gpg --no-options --no-auto-check-trustdb --no-default-keyring \
		--keyring "./output/keyrings/$k" --list-keys --with-colons \
		| grep -a '^pub' \
		| awk -F: -v keyring=$1 \
		'BEGIN { ok = 1 } \
		$2 == "r" {print keyring ":\t0x" $5 " is revoked"; ok = 0} \
		END { if (!ok) { exit 1 } }'
}

fail=0
for keyring in zsien-keyring.gpg; do
	find_revoked $keyring
done

exit $fail
