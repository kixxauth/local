Encrypting Files
================
There are 3 tools for encrypting files before sending or storing them elsewhere:

1. genkey
2. encryptfiles --key --input --output
3. decryptfiles --key --input --output

The general tactic is to use `genkey` to create a 32 byte key and save it somewhere.

```
node Projects/Kris/webserver/tools/cli.js genkey > ~/Documents/key-2023-07-23.txt
```

That key is then used to encrypt and decrypt files. For example, take the `~/.secrets` directory:

```
/Users/kwalker/.secrets/
└── certificates
    ├── admin_server.cert
    ├── admin_server.key
    ├── kixx_name.ca
    ├── kixx_name.cert
    └── kixx_name.key
```

To encrypt each file and duplicate the file tree elsewhere:

```
node local/libjs/encrypt-files/cli.js encryptfiles \
  --key 59648774bc92986da4fb0e05aa61f2db59491d167385105c328ff331c4a74e61 \
  --input ~/.secrets/
  --output ~/Downloads/
```

This will create a directory like `~/Downloads/secrets-2023-07-23T13-54-11/`.

Then, zip up the result to transfer elsewhere:

```
zip -r ~/Downloads/secrets-2023-07-23T13-54-11.zip ~/Downloads/secrets-2023-07-23T13-54-11
```

In the new location, unzip it:

```
unzip secrets-2023-07-23T13-54-11.zip
```

Then use our decryption tool to do the rest:

```
node local/libjs/encrypt-files/cli.js decryptfiles \
  --key 59648774bc92986da4fb0e05aa61f2db59491d167385105c328ff331c4a74e61 \
  --input ./secrets-2023-07-23T13-54-11 \
  --output ~/Documents/my_secrets
```

```
tree ~/Documents/my_secrets/

/Users/kwalker/Documents/my_secrets/
└── certificates
    ├── admin_server.cert
    ├── admin_server.key
    ├── kixx_name.ca
    ├── kixx_name.cert
    └── kixx_name.key
```
