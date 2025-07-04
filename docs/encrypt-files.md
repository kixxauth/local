Encrypting Files
================
There are 3 tools for encrypting files before sending or storing them elsewhere:

1. genkey
2. encrypt-files [key] [input_dir] [output_dir]
3. decrypt-files [key] [input_dir] [output_dir]

Use `genkey` to create a 32 byte key and save it somewhere.

```
ksys genkey > ~/Documents/key-2023-07-23.txt
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
ksys encrypt-files \
  59648774bc92986da4fb0e05aa61f2db59491d167385105c328ff331c4a74e61 \
  ~/.secrets/ \
  ~/Downloads/
```

This will create a zip archive like `~/Downloads/secrets-2023-07-23T13-54-11.zip`.
```

In the new location, unzip it:

```
unzip secrets-2023-07-23T13-54-11.zip
```

Then use our decryption tool to do the rest:

```
ksys decrypt-files \
  59648774bc92986da4fb0e05aa61f2db59491d167385105c328ff331c4a74e61 \
  ./secrets-2023-07-23T13-54-11 \
  ~/Documents/my_secrets
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
