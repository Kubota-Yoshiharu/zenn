#!/bin/sh
# https://learn.microsoft.com/ja-jp/azure/iot-edge/how-to-provision-devices-at-scale-linux-tpm?view=iotedge-1.4&tabs=physical-device%2Cubuntu#install-the-tpm2-tools

if [ "$USER" != "root" ]; then
  SUDO="sudo "
fi

$SUDO tpm2_readpublic -Q -c 0x81010001 -o ek.pub 2> /dev/null
if [ $? -gt 0 ]; then
  # Create the endorsement key (EK)
  $SUDO tpm2_createek -c 0x81010001 -G rsa -u ek.pub

  # Create the storage root key (SRK)
  $SUDO tpm2_createprimary -Q -C o -c srk.ctx > /dev/null

  # make the SRK persistent
  $SUDO tpm2_evictcontrol -c srk.ctx 0x81000001 > /dev/null

  # open transient handle space for the TPM
  $SUDO tpm2_flushcontext -t > /dev/null
fi

printf "Gathering the registration information...\n\nRegistration Id:\n%s\n\nEndorsement Key:\n%s\n" $(sha256sum -b ek.pub | cut -d' ' -f1 | sed -e 's/[^[:alnum:]]//g') $(base64 -w0 ek.pub)
$SUDO rm ek.pub srk.ctx 2> /dev/null
