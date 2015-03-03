#!/bin/sh

merge_loop () {
  SRCFILE=$1
  DESTFILE=$2

  echo ''
  MERGE_AGAIN=yes
  while [ "${MERGE_AGAIN}" = "yes" ]; do
    # Prime file.merged so we don't blat the owner/group id's
    cp -p "${SRCFILE}" "${SRCFILE}.merged"
    sdiff -o "${SRCFILE}.merged" --text --suppress-common-lines \
      --width=${SCREEN_WIDTH:-80} "${DESTFILE}" "${SRCFILE}"
    INSTALL_MERGED=V
    while [ "${INSTALL_MERGED}" = "v" -o "${INSTALL_MERGED}" = "V" ]; do
      echo ''
      echo "  Use 'i' to install merged file"
      echo "  Use 'r' to re-do the merge"
      echo "  Use 'v' to view the merged file"
      echo "  Default is to leave the temporary file to deal with by hand"
      echo ''
      echo -n "    *** How should I deal with the merged file? [Leave it for later] "
      read INSTALL_MERGED

      case "${INSTALL_MERGED}" in
      [iI])
        cp "${SRCFILE}.merged" "${DESTFILE}"
        rm "${SRCFILE}.merged"
        unset MERGE_AGAIN
        ;;
      [rR])
        rm "${SRCFILE}.merged"
        ;;
      [vV])
        ${PAGER} "${SRCFILE}.merged"
        ;;
      '')
        echo "   *** ${SRCFILE} will remain for your consideration"
        unset MERGE_AGAIN
        ;;
      *)
        echo "invalid choice: ${INSTALL_MERGED}"
        INSTALL_MERGED=V
        ;;
      esac
    done
  done
}

# Loop showing user differences between files, allow merge, skip or install
# options
diff_loop () {
  SRCFILE=$1
  DESTFILE=$2
  HANDLE_SRCFILE=v
  while [ "${HANDLE_SRCFILE}" = "v" -o "${HANDLE_SRCFILE}" = "V" -o \
    "${HANDLE_SRCFILE}" = "NOT V" ]; do
    if [ -f "${DESTDIR}${SRCFILE#.}" -a -f "${SRCFILE}" ]; then
      if [ "${HANDLE_SRCFILE}" = "v" -o "${HANDLE_SRCFILE}" = "V" ]; then
	echo ''
	echo '   ======================================================================   '
	echo ''
        (
          echo "  *** Displaying differences between ${SRCFILE} and installed version:"
          echo ''
          diff ${DIFF_FLAG} ${DIFF_OPTIONS} "${SRCFILE#.}" "${DESTFILE}"
        ) | ${PAGER}
        echo ''
      fi
    fi

    echo "  Use 'i' to install the temporary ${SRCFILE}"
    echo "  Use 'l' to leave untouched installed file ${DESTFILE}"
    echo "  Use 'm' to merge the temporary and installed versions"
    echo "  Use 'v' to view the diff results again"
    echo ''
    echo -n "How should I deal with this? [Leave it for later] "
    read HANDLE_SRCFILE

    case "${HANDLE_SRCFILE}" in
    [dDlL])
      echo ''
      echo "   *** Leaving  ${DESTFILE}"
      ;;
    [iI])
      echo ''
      cp "${SRCFILE}" "${DESTFILE}"
      ;;
    [mM])
      merge_loop "${SRCFILE}" "${DESTFILE}"
      ;;
    [vV])
      continue
      ;;
    *)
      # invalid choice, show menu again.
      echo "invalid choice: ${HANDLE_SRCFILE}"
      echo ''
      HANDLE_SRCFILE="NOT V"
      continue
      ;;
    esac  # End of "How to handle files that are different"
  done
  echo ''
}
