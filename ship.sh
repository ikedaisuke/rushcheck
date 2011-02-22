#!/bin/sh

for f in Rakefile lib/rushcheck/version.rb
do
  sed -e "s/@VERSION@/$*/" $f.in > $f
done
