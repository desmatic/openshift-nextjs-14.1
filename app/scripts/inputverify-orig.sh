#Script to validate input files in GeminiMipi project
# This script accepts 1 parameters
# - 1: Directory/Filename
#
# Created By : Accenture
# Creation Date : 24/04/2016
# Modified Date : 21/04/2016
# Modification History :
# -------------------------------------------------------
#------------------------------------------
# Header and footer validation script
#------------------------------------------
StrFilename=$(basename $1)
echo "Filename base is $StrFilename"
#for test ValidationLog="./logs/$STR_FILENAME""_$1"".log"
ValidationLog="./logs/FileValidation$StrFilename"".log"
#------------------------------------------
# Check filesize and binary Bytes 
#------------------------------------------
if [[ ! -s $1 ]] # Checking if the file is 0 byte file
then
	echo "<code>FILE_ERR</code><detail>Error: Zero Byte file found .The file name is $1</detail>"  >>  $ValidationLog
	VALIDATION_STATUS='1'
exit $VALIDATION_STATUS
fi

bin_count=$(od -c $1 |  grep -c '\\r' ) #Check if there are binary files
if [[ $bin_count != 0 ]]
then
		echo "<code>FILE_ERR</code><detail>Error Binary characters found in the file $1</detail>"  >> $ValidationLog
		VALIDATION_STATUS='1'
		echo $VALIDATION_STATUS	
fi
#------------------------------------------
# Header and validation 
#------------------------------------------
IntHeaderFieldNum=$(head -1 $1 | awk -F 'Ï' '{print NF}')
if [[ $IntHeaderFieldNum != 6 ]]
	then
		echo "<code>FILE_ERR</code><detail>Error: Invalid number of fields in the header record, required 6</detail>"  >> $ValidationLog
		VALIDATION_STATUS='1'
fi

Header_trans_code=$(head -1 $1| awk -F'Ï' '{print $1}')
organization_id=$(head -1 $1| awk -F'Ï' '{print $2}')
FileContain_extension=$(head -1 $1| awk -F'Ï' '{print $3}')
Date_field=$(head -1 $1| awk -F'Ï' '{print $4}')
time_field=$(head -1 $1| awk -F'Ï' '{print $5}')
Sequence_number=$(head -1 $1| awk -F'Ï' '{print $6}')
echo 'Header_trans_code is: ' $Header_trans_code
echo 'Organization Id is: '$organization_id
echo 'File extension is: '$FileContain_extension
echo 'Date field is: ' $Date_field
echo 'Time Field is: '$time_field
echo 'Sequence is: ' $Sequence_number
	
if [[ "$Header_trans_code" != "A00" ]] #Validating the header transaction type
then
   echo "<code>FILE_ERR</code><detail>Error: Invalid header transaction type $Header_trans_code</detail>"  >> $ValidationLog
   VALIDATION_STATUS='1'
fi
if [[ "$organization_id" != "XOSERVE" ]] #Validating the organization ID
then
	echo "<code>FILE_ERR</code><detail>Error: Invalid Organization ID $organization_id</detail>"  >> $ValidationLog
	VALIDATION_STATUS='1'	
fi
filename_ext=$(echo $StrFilename| cut -c 16-18)
echo "<code>FILE_ERR</code><detail>Filename Base ext is: $filename_ext</detail>"
if [[ "$FileContain_extension" != "$filename_ext" ]] #Validating the extension 
then
   VALIDATION_STATUS='1'
   echo "<code>FILE_ERR</code><detail>Error: INVALID_FILE_EXTENSION Filename: $FileContain_extension is not equal to $filename_ext</detail>" >> $ValidationLog # Error File extension
   fi

filename_counter=$(echo $StrFilename| cut -c 9-14)
echo "filename Counert is $filename_counter"
if [[ "$Sequence_number" != "$filename_counter" ]]
then
   echo "<code>FILE_ERR</code><detail>Error: The sequence number in the header $Sequence_number and the filename $filename_counter does not match</detail>"  >> $ValidationLog
   VALIDATION_STATUS='1'
fi
#------------------------------------------
# Footer validation 
#------------------------------------------
IntFooterFieldNum=$(tail -1 $1 | awk -F 'Ï' '{print NF}')
if [[ $IntFooterFieldNum != 2 ]]
	then
		echo "<code>FILE_ERR</code><detail>Error: Invalid number of fields in the footer record, recquired 2</detail>"  >> $ValidationLog
		VALIDATION_STATUS='1'
fi
Footer_trans_code=$(tail -1 $1| awk -F'Ï' '{print $1}')
Footer_rec_count=$(tail -1 $1| awk -F'Ï' '{print $2}')	

echo 'Footer_trans_code is: ' $Footer_trans_code
echo 'Footer_rec_count is: '$Footer_rec_count
if [[ "$Footer_trans_code" != "Z99" ]] #Validating the Footer transaction type
then
	echo "<code>FILE_ERR</code><detail>Invalid footer transaction type $Footer_trans_code</detail>"  >> $ValidationLog
		VALIDATION_STATUS='1'
fi
IntFileLineCount=$(wc -l $1| awk -F' ' '{print $1}') #Count the file lines
echo "Lines in the files are $IntFileLineCount"	
	content_line_count=$(expr $IntFileLineCount - 2)
if [[ "$content_line_count" != "$Footer_rec_count" ]] #Validating the Footer count with the number of data records in the file
then
	{
		echo "<code>FILE_ERR</code><detail>footer count mismatch Footer counter $Footer_rec_count and lines in file is $content_line_count</detail>"  >> $ValidationLog
		VALIDATION_STATUS='1'
	}
fi
exit $VALIDATION_STATUS
