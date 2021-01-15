# RHM Cluster with CodeReady Containers

CRC setup on Windows.

### CRC install
Follow the instructions as shown in this [video](https://www.youtube.com/watch?v=yp8LXEKlGSQ)

#### Download
File and pull secret.

#### Install
Run the command `crc setup`.

```
PS C:\Utils\crc-windows-1.8.0-amd64> crc setup
INFO Checking if oc binary is cached
INFO Caching oc binary
INFO Checking if podman remote binary is cached
INFO Checking if CRC bundle is cached in '$HOME/.crc'
INFO Unpacking bundle from the CRC binary
INFO Checking if running as normal user
INFO Checking Windows 10 release
INFO Checking if Hyper-V is installed and operational
INFO Checking if user is a member of the Hyper-V Administrators group
INFO Checking if Hyper-V service is enabled
INFO Checking if the Hyper-V virtual switch exist
INFO Found Virtual Switch to use: Default Switch
Setup is complete, you can now run 'crc start' to start the OpenShift cluster
```

