#!/bin/sh
# Compares the DM keyring with the DD keyring. If the same name or email is
# in both keyrings, that's an error.
set -e

list_uids () {
	gpg --no-options --no-auto-check-trustdb --no-default-keyring \
		--keyring "$1" --list-keys | grep -a '^uid' | sed 's/^uid *//' |
		egrep -a -v '\[jpeg image of size .*\]'
}

list_names () {
	sed 's/ <.*>//'
}

list_emails () {
	sed 's/.* <\(.*\)>/\1/'
}

fail=0

dd_uids=$(list_uids ./output/keyrings/zsien-keyring.gpg)
(
	echo "$dd_uids" | list_emails
	echo "$dd_uids" | list_names
	echo "$dd_uids"
) | sort | uniq > dd-list.tmp

IFS="
"
rm -f dd-list.tmp

exit $fail
