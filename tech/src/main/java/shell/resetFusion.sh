#!/bin/bash
diskutil resetFusion
diskutil list
diskutil cs create Macintosh\ HD identifier1 identifier2
diskutil cs list
diskutil cs createVolume logicalvolumegroup jhfs+ Macintosh\ HD 100%