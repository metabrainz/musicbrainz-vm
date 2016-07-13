#!/bin/bash

vboxmanage showvminfo musicbrainz-vm --machinereadable | grep Controller-ImageUUID-0-0 | grep -o '[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}'
