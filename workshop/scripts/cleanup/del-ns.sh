 #!/bin/bash
 CONTEXT=`cat ~/.kube/config | grep current-context | cut -d'/' -f2`
 HOST=`cat ~/.kube/config | grep -B1 $CONTEXT | grep server | cut -d' ' -f6`
 oc get ns $1 -o json > tmp.json
# .bak extension for Mac users 
sed -i '.bak' '/kubernetes/d' tmp.json
 curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $(oc whoami -t)" -X PUT --data-binary @tmp.json $HOST/api/v1/namespaces/$1/finalize


