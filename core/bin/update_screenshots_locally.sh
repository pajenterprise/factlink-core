#!/bin/bash
cd `dirname $0`/..
ls tmp/capybara/ |grep -v -e '-diff.png' | xargs -n 1 -I '{}' mv 'tmp/capybara/{}' spec/screenshots/screenshots/
