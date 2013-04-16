e are useful, or at worst not harmful, for all images we build.

set -e

[ -n "$ARCH" ]
[ -n "$TARGET_ROOT" ]

IMG_PATH=~/.cache/image-create
DIB_CLOUD_IMAGES=${DIB_CLOUD_IMAGES:-http://cloud-images.ubuntu.com/}
DIB_RELEASE=${DIB_RELEASE:-precise}
BASE_IMAGE_FILE=${BASE_IMAGE_FILE:-$DIB_RELEASE-server-cloudimg-$ARCH-root.tar.gz}
SHA256SUMS=${SHA256SUMS:-https://${DIB_CLOUD_IMAGES##http?(s)://}/$DIB_RELEASE/current/SHA256SUMS}

mkdir -p $IMG_PATH
# TODO: don't cache -current forever.
if [ ! -f $IMG_PATH/$BASE_IMAGE_FILE ] ; then
   echo "Fetching Base Image"
   #wget $SHA256SUMS -O $IMG_PATH/SHA256SUMS.ubuntu.$DIB_RELEASE.$ARCH
   wget https://cloud-images.ubuntu.com/precise/current/SHA256SUMS -O $IMG_PATH/SHA256SUMS.ubuntu.$DIB_RELEASE.$ARCH

   wget $DIB_CLOUD_IMAGES/$DIB_RELEASE/current/$BASE_IMAGE_FILE -O $IMG_PATH/$BASE_IMAGE_FILE.tmp
   pushd $IMG_PATH
   awk "/$BASE_IMAGE_FILE/ { print \$0 \".tmp\" }" SHA256SUMS.ubuntu.$DIB_RELEASE.$ARCH | sha256sum --check -
   popd
   mv $IMG_PATH/$BASE_IMAGE_FILE.tmp $IMG_PATH/$BASE_IMAGE_FILE
fi
# Extract the base image
sudo tar -C $TARGET_ROOT -xzf $IMG_PATH/$BASE_IMAGE_FILE
