#!/usr/bin/env bash

set -e

function tellApplicable() {
    printf "true\n" "1do par"
    printf "true\n" "2do par"
    printf "true\n" "3do par"
}

function tellVersion() {
    echo "per file v1"
}

function run() {
        date >> /tmp/x.sh.run.log
        echo "Args: $*" >> /tmp/x.sh.run.log
        printf "Stdin: " >> /tmp/x.sh.run.log
        cat <&0 >> /tmp/x.sh.run.log
        echo '{ "toolNotes" : [
                   { "type" : "type during run",
                     "message" : "run message",
                     "file" : "a.c",
                     "line" : 3,
                     "noteId" : "noteid"
                   }
                ]
              , "warnings" : [
                  { "display_message" : "display warning during run"
                  , "detailed_message" : "detailed warning during run"
                  }
                ] 
              }'
}

function finalize() {
        date >> /tmp/x.sh.finalize.log
        echo "Args: $*" >> /tmp/x.sh.finalize.log
        printf "Stdin: " >> /tmp/x.sh.finalize.log
        cat <&0 >> /tmp/x.sh.finalize.log
        echo "" >> /tmp/x.sh.finalize.log
        local pr_branch="v3-tool-run-and-finish-$(date '+%F_%0H-%0M-%0S_%N')"
        echo "Checking out ${pr_branch} locally" >> /tmp/x.sh.finalize.log
        git checkout -b $pr_branch &> /dev/null
        echo "" >> /tmp/x.sh.finalize.log
        cat <<EOF
{ "toolNotes" : [
    { "type" : "type during finalize",
      "message" : "finalize message",
      "file" : "a.c",
      "line" : 3,
      "noteId" : "noteid"
    }
  ]
, "pullRequest" : {
      "title": "x.sh PR",
      "body": "Bug fixes and performance improvements",
      "target_branch": null,
      "source_commit": ""
  }
, "warnings" : [ 
    { 
      "display_message": "display warning during finalize",
      "detailed_message": "detailed warning during finalize"
    }
  ]
}
EOF
}

function tellName() {
        printf "V3Test"
}

case "$3" in
    run)
        run
        ;;
    finalize)
        finalize
        ;;
    applicable)
        tellApplicable
        ;;
    name)
        tellName
        ;;
    *)
        tellVersion
        ;;
esac
