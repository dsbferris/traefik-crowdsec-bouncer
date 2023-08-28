#!/bin/bash  
version=$(<VERSION)
tag=$(<TAG)
echo Building $tag:$version ...

docker build -t "$tag:$version" .