#!/bin/bash

/usr/bin/printenv
ls


###Below are 3 blocks of main.sh under the heading

###OphidiaContainer main.sh
OUTFILE=$( mktemp output-XXXX.csv )
echo $OUTFILE >> $OUTPUT__output_files

$DEP__OphidiaTerminal__oph_term oph_term -u $1 $PROP__u -p $2 $PROP__p -H $3 $PROP__H -P $4 $PROP__P -e "oph_createcontainer container=$PROP__container;dim=$PROP__dim;dim_type=$PROP__dim_type;hierarchy=$PROP__hierarchy;" | tee -a "$OUTFILE"
##More parameters are required to be entered and further improvements to be made so the request commands do not accept nulls.

###OphidiaImportCube main.sh
OUTFILE=$( mktemp output-XXXX.csv )
echo $OUTFILE >> $OUTPUT__output_files 

$DEP__OphidiaTerminal__oph_term oph_term -u $1 $PROP__u -p $2 $PROP__p -H $3 $PROP__H -P $4 $PROP__P -e "oph_importnc container=$PROP__container;exp_dim=$PROP__exp_dim;host_partition=$PROP__host_partition;imp_dim=$PROP__imp_dim;measure=$PROP__measure;src_path=$PROP__src_path;compressed=$PROP__compressed;exp_concept_level=$PROP__exp_concept_level;filesystem=$PROP__filesystem;imp_concept_level=$PROP__imp_concept_level;ndb=$PROP__ndb;ndbms=$PROP__ndbms;nhost=$PROP__nhost;subset_filter=$PROP__subset_filter;subset_dims=$PROP__subset_dims;subset_type=$PROP__subset_type;" | tee -a "$OUTFILE"

$DEP__OphidiaTerminal__oph_term oph_term -u $1 $PROP__u -p $2 $PROP__p -H $3 $PROP__H -P $4 PROP__P -e "oph_explorecube cube=$PROP__pid;limit_filter=$PROP__limit_filter=50;sessionid=$PROP__sessionid;" | tee -a "$OUTFILE"

cat $OUTFILE | jq -c -r '.response.response[0].objcontent[0].rowkeys[0:3],.response.response[0].objcontent[0].rowvalues[range(0;100)]' | sed 's/[][]//g' > $OUTFILE
###range required to change in future to adjust accordingly to the Ophidia commands

###OphidiaJSONtoCSV  main.sh
OUTFILE=$( mktemp output-XXXX.csv )
echo $OUTFILE >> $OUTPUT__output_files
echo $INPUT__input_files


ID="0;100"   ##Can be set as to a Property for improvement
minimumRange="0;1" #minimum range required to accept in the commands 
maximumRange="0;10000" #maximum required to accept in the commands

if [[ "$ID" == "$minimumRange" ]]
then
echo "Not in the valid parameters"
else

cat $INPUT__input_files | jq -c -r ".response.response[0].objcontent[0].rowkeys[0:3],.response.response[0].objcontent[0].rowvalues[range($ID)] " | sed 's/[][]//g' | tee -a "$OUTFILE"
##Above is the JSON template to retrieve the required arrays and extract the important variables for conversion
fi



