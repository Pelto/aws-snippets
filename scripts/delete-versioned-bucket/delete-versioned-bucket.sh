#!/bin/bash

# Built upon https://gist.github.com/weavenet/f40b09847ac17dd99d16

set -e

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -b|--bucket)
        bucket="$2"
        shift
        ;;
        *)
        # Unknown
        ;;
    esac
    shift # past argument or value
done

if [[ -z $bucket ]]; then
    echo "Bucket must be specified by either -b or --bucket"
    exit 1
fi

echo "Removing all versions from $bucket"

versions=`aws s3api list-object-versions --bucket $bucket |jq '.Versions'`
markers=`aws s3api list-object-versions --bucket $bucket |jq '.DeleteMarkers'`
let count=`echo $versions |jq 'length'`-1

if [ $count -gt -1 ]; then
    echo "removing files"
    for i in $(seq 0 $count); do
        key=`echo $versions | jq .[$i].Key |sed -e 's/\"//g'`
        versionId=`echo $versions | jq .[$i].VersionId |sed -e 's/\"//g'`
        aws s3api delete-object \
            --bucket $bucket \
            --key $key \
            --version-id $versionId
    done
fi

let count=`echo $markers |jq 'length'`-1

if [ $count -gt -1 ]; then
    echo "removing delete markers"

    for i in $(seq 0 $count); do
        key=`echo $markers | jq .[$i].Key |sed -e 's/\"//g'`
        versionId=`echo $markers | jq .[$i].VersionId |sed -e 's/\"//g'`
        aws s3api delete-object \
            --bucket $bucket \
            --key $key \
            --version-id $versionId
    done
fi

aws s3 rb --force s3://$bucket
