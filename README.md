# snxt
Package **snxt** contains functions frequently used at the JPAL networks lab. It contains the following functions (readme updated on 30th July 2020)

1. **pull_data** and **pull_media** use the api provided by surveycto to download data directly to R. Either encrypted or un-encrypted data and media files can be downloaded using these functions.
2. **vc_mount** and **vc_dismount** respectively mount and dismount veracrypt containers from within R. This integrates veracrypt with R so the workflow can be managed directly from within R.
