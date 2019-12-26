all: output/keyrings/zsien-keyring.gpg output/sha512sums.txt output/README output/changelog

output/keyrings/zsien-keyring.gpg: zsien-keyring-gpg zsien-keyring-gpg/0x*
	cat zsien-keyring-gpg/0x* > output/keyrings/zsien-keyring.gpg

output/sha512sums.txt: output/keyrings/zsien-keyring.gpg
	cd output; sha512sum keyrings/* > sha512sums.txt

output/README: README
	cp README output/

output/changelog: debian/changelog
	cp debian/changelog output/

output/openpgpkey: output/keyrings/zsien-keyring.gpg
	cd output && ../scripts/update-keyrings build-wkd debian.org keyrings/zsien-keyring.gpg

test: all
	./runtests

clean:
	rm -f output/keyrings/*.gpg output/sha512sums.txt output/README output/changelog output/keyrings/*~
	rm -rf gpghome output/openpgpkey
