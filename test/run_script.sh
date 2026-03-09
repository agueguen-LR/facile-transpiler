# This script technically turns this project into an interpreter huh

if [ -z "$1" ]; then
  echo "Usage: $0 <script_path>"
  exit 1
fi

if [[ !( "$1" =~ ^"../test" ) ]]; then
	echo "You should be in the build directory"
	exit 1
fi

FILE_NAME=$(basename "$1" .facile)

make
./facile ../test/$FILE_NAME.facile
ilasm "$FILE_NAME.il"
mono "$FILE_NAME.exe"
