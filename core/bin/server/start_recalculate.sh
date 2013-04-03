#!/bin/bash
count=`ps x | grep -v grep | grep -c 'rake fact_graph:recalculate'`

if [ "$count" -lt "1" ]; then
  . /home/deploy/.bash_profile

  cd /applications/core/current

  export PIDFILE=/home/deploy/recalculate.pid
  export NEWRELIC_DISPATCHER="FactGraph recalculate"

  nice -n 10 nohup /usr/local/rbenv/shims/bundle exec rake environment fact_graph:recalculate >> /applications/core/current/log/fact_graph.log 2>&1
fi
exit 0
