#!/bin/bash

/usr/bin/printenv

OUTFILE=$( mktemp output-XXXX.csv )
echo $OUTFILE >> $OUTPUT__output_files

$DEP__OphidiaTerminal__oph_term oph_term -u $1 $PROP__u -p $2 $PROP__p -H $3 $PROP__H -P $4 $PROP__P -e "oph_createcontainer container=$PROP__container;dim=$PROP__dim;dim_type=$PROP__dim_type;hierarchy=$PROP__hierarchy;" | tee -a "$OUTFILE"
##More parameters are required to be entered and further improvements to be made so the request commands do not accept nulls.
ls
