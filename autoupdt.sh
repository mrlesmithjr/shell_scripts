 #!/bin/bash
#
# use aptitude to automatically install updates. log and email any
# changes.
#

#
# variables to change
#

# address to send results to
MAILTO=
# host name of smtp server
MAIL=


#
# script is below here (do not change)
#

tmpfile=$(mktemp)

#
# smtp setup commands
#

echo "helo $(hostname)" >> ${tmpfile}
echo "mail from: root@$(hostname)" >> ${tmpfile}
echo "rcpt to: $MAILTO" >> ${tmpfile}
echo 'data'>> ${tmpfile}
echo "subject: Aptitude cron $(date)" >> ${tmpfile}

#
# actually run aptitude to do the updates, logging its output
#

echo "aptitude update" >> ${tmpfile}
aptitude update >> ${tmpfile} 2>&1
echo "" >> ${tmpfile}
echo "aptitude safe-upgrade" >> ${tmpfile}
aptitude -y safe-upgrade >> ${tmpfile} 2>&1
echo "" >> ${tmpfile}
echo "aptitude clean" >> ${tmpfile}
aptitude clean >> ${tmpfile} 2>&1

#
# i get a lot of escaped new lines in my output. so the following
# removes them. this could be greatly improved

tmpfile2=$(mktemp)
cat ${tmpfile} | sed 's/\r\r/\n/g'|sed 's/\r//g' > ${tmpfile2}
mv ${tmpfile2} ${tmpfile}

#
# smtp close commands
#

echo >> ${tmpfile}
echo '.' >> ${tmpfile}
echo 'quit' >> ${tmpfile}
echo >> ${tmpfile}

#
# now send the email (and ignore output)
#

telnet $MAIL 25 < ${tmpfile} > /dev/null 2> /dev/null

#
# and remove temp files
#

rm -f ${tmpfile}
